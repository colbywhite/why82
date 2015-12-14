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
        handle_missing_game game_json, season, games_json
      end
      log_on_200th i, season
    end
  end

  def handle_missing_game(game_json, season, games_json)
    logger.warn 'The given game was not found in the DB as is. Looking for one with a different time'
    logger.warn "game=[#{game_json}"
    home = Team.find_by name: game_json[:home][:name], abbr: game_json[:home][:abbr]
    away = Team.find_by name: game_json[:away][:name], abbr: game_json[:away][:abbr]
    match_ups = season.games_against home, away
    orphan_games = match_ups.reject { |m| game_in_bball_ref? m, games_json }
    unless orphan_games.count == 1
      # If there are two games moved between the same two teams, then I will have two orphans.
      # In that scenario, I do not know which is which and thus don't know which one to update.
      # If there are no orphans, I have no game to update. This scenario should never happen
      orphan_string = orphan_games.collect(&:to_string)
      fail "Incorrect num of orphans found (#{orphan_games.count} for #{game_json}: #{orphan_string}"
    end

    orphan_game = orphan_games.first
    logger.warn "Updating both the score and time for #{orphan_game.to_string}"
    orphan_game.update home_score: game_json[:home][:score], away_score: game_json[:away][:score],
                       time: game_json[:time]
    orphan_game.reload
    logger.warn "Updated game to: #{orphan_game.to_string}"
  end

  def game_in_bball_ref?(game, games_json)
    home = game.home
    away = game.away
    found = games_json.select do |g|
      g[:home][:abbr] == home.abbr && g[:home][:name] == home.name &&
      g[:away][:abbr] == away.abbr && g[:away][:name] == away.name &&
      g[:time] == game.time
    end
    !found.empty?
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
    Exceptions::TooManyGamesException.raise_if season.games.count
    Exceptions::TooManyTeamsException.raise_if season.teams.count
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
