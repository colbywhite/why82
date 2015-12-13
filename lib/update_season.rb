class UpdateSeason
  include BballRef::Parser
  include ICanHazIp

  attr_reader :name, :short_name

  LEAGUE_NAME = 'National Basketball Association'
  LEAGUE_ABBR = 'NBA'

  def initialize(name, short_name)
    @name = name
    @short_name = short_name
  end

  def logger
    Rails.logger
  end

  def perform
    if BballRef::Checker.check
      process_season
    else
      logger.error 'Aborting UpdateSeason since BballRef cannot be reached'
    end
  end

  def process_season
    season = get_season name, short_name
    logger.info "Updating #{LEAGUE_ABBR} season #{season.short_name}"
    games = bball_ref_games season

    # TODO: fail if bballref has a  diff amount if incomplete games than i do
    # TODO: quit when there are no games left
    logger.info "Checking #{games.count} of #{season.incomplete_games.count} incomplete games"
    process_games_in_transaction games, season
  end

  def process_games_in_transaction(games_json, season)
    ActiveRecord::Base.transaction do
      logger.info "Starting status: #{status_str(season)}"
      process_games games_json, season
      validate_season season
      logger.info "Ending status: #{status_str(season)}"
    end
  end

  def process_games(games_json, season)
    games_json.each_with_index do |game_json, i|
      game = get_game game_json, season
      if game
        game.update home_score: game_json[:home][:score], away_score: game_json[:away][:score]
      else
        logger.warn "The game: #{game_json} was not found in the DB. Ignoring"
      end
      log_on_200th i, season
    end
  end

  def log_on_200th(i, season)
    return unless (i + 1) % 200 == 0
    logger.info "  #{i + 1} games processed"
    logger.info "  Status: #{status_str(season)}"
  end

  def status_str(season)
    "#{season.games.count} games & #{season.teams.count} teams"
  end

  def validate_season(season)
    teams = season.teams
    danger_teams = teams.select { |t| t.games(season).count != 82 }
    danger_teams.each { |t| logger.warn "#{t.name} has too many games" }
    Exceptions::TooManyGamesException.raise_if season.games.count
    Exceptions::TooManyTeamsException.raise_if teams.count
  end

  def league
    League.where(name: LEAGUE_NAME, abbr: LEAGUE_ABBR).first
  end

  def get_season(name, short_name)
    season = Season.where(name: name, short_name: short_name,
                          league: league).first
    fail "Season(name: #{name}, short_name: #{short_name}) does not exist" unless season
    season
  end

  def get_team(team_info, season)
    team = season.teams.find_by name: team_info[:name], abbr: team_info[:abbr]
    unless team
      fail "Team(name: #{team_info[:name]}, abbr: #{team_info[:abbr]}, season: #{season.short_name}) does not exist"
    end
    team
  end

  def get_game(game_json, season)
    home = get_team game_json[:home], season
    away = get_team game_json[:away], season
    time = game_json[:time]
    game = season.game_class.find_by(home: home, away: away, time: time)
    game
  end
end
