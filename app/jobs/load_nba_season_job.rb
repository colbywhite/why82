require 'exceptions'

class LoadNbaSeasonJob < ActiveJob::Base
  include ParseHubParser
  include ParseHubRunner
  queue_as :default
  LEAGUE_NAME = 'National Basketball Association'
  LEAGUE_ABBR = 'NBA'

  def perform(name, short_name)
    start_run_and_wait SEASON_PROJECTS[short_name]
    process_season name, short_name
  end

  def process_season(name, short_name)
    ActiveRecord::Base.transaction do
      logger.info "Loading #{LEAGUE_ABBR} season #{short_name}"
      season = create_season name, short_name
      logger.info "Starting status: #{status_str(season)}"
      games_json = pull_season_json season
      process_games games_json, season
      logger.info "Ending status: #{status_str(season)}"
      validate_season season
    end
  end

  def process_games(games_json, season)
    games_json.each_with_index do |game_json, i|
      create_game game_json, season
      if (i + 1) % 200 == 0
        logger.info "  #{i + 1} games processed"
        logger.info "  Status: #{status_str(season)}"
      end
    end
  end

  def status_str(season)
    "#{season.games.count} games & #{season.teams.count} teams"
  end

  def validate_season(season)
    Exceptions::TooManyGamesException.raise_if season.games.count
    Exceptions::TooManyTeamsException.raise_if season.teams.count
  end

  def league
    League.where(name: LEAGUE_NAME, abbr: LEAGUE_ABBR).first_or_create
  end

  def create_season(name, short_name)
    Season.where(name: name, short_name: short_name,
                 league: league).first_or_create
  end

  def create_team(name, abbr, season)
    team = Team.find_or_create_by(name: name, abbr: abbr)
    team.seasons += [season]
    team
  end

  def create_game(game_json, season)
    home = create_team game_json[HOME], game_json[HOME_ABBR], season
    away = create_team game_json[AWAY], game_json[AWAY_ABBR], season
    game = season.game_class.find_or_create_by(home: home, away: away,
                                               time: build_time(game_json))
    game.home_score = game_json[HOME_SCORE]
    game.away_score = game_json[AWAY_SCORE]
    game.save
  end
end
