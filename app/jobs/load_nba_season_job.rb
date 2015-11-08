class LoadNbaSeasonJob < ActiveJob::Base
  include BballRefParser
  queue_as :default
  LEAGUE_NAME = 'National Basketball Association'
  LEAGUE_ABBR = 'NBA'

  def perform(name, short_name)
    logger.info "Loading #{LEAGUE_ABBR} season #{short_name}"
    season = create_season name, short_name
    logger.info "Starting status: #{status_str(season)}"
    games_html = pull_season_html season
    process_games games_html, season
    logger.info "Ending status: #{status_str(season)}"
  end

  def process_games(games_html, season)
    games_html.each_with_index do |game_html, i|
      game_info = parse_game_html game_html, season
      create_game game_info, season
      if (i + 1) % 200 == 0
        logger.info "  #{i + 1} games processed"
        logger.info "  Status: #{status_str(season)}"
      end
    end
  end

  def status_str(season)
    "#{season.games.count} games & #{season.teams.count} teams"
  end

  def league
    League.where(name: LEAGUE_NAME, abbr: LEAGUE_ABBR).first_or_create
  end

  def create_season(name, short_name)
    Season.where(name: name, short_name: short_name,
                 league: league).first_or_create
  end

  def create_team(team_info, season)
    team = Team.find_or_create_by(name: team_info[:name],
                                  abbr: team_info[:abbr])
    team.seasons += [season]
    team
  end

  def create_game(game_info, season)
    home = create_team game_info[:home], season
    away = create_team game_info[:away], season
    game = season.game_class.find_or_create_by(home: home, away: away,
                                               time: game_info[:time])
    game.home_score = game_info[:home][:score]
    game.away_score = game_info[:away][:score]
    game.save
  end
end
