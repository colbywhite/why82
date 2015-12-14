class UpdateSeason
  include BballRef::Parser
  include BballRef::Utils
  include ICanHazIp
  include AccessRailsLogger

  attr_reader :name, :short_name, :season, :league

  LEAGUE_NAME = 'National Basketball Association'
  LEAGUE_ABBR = 'NBA'

  def initialize(name, short_name)
    @name = name
    @short_name = short_name
    @league = League.find_by name: LEAGUE_NAME, abbr: LEAGUE_ABBR
    @season = get_season name, short_name
  end

  def perform
    if BballRef::Checker.check
      update_season
    else
      logger.error 'Aborting UpdateSeason since BballRef cannot be reached'
    end
  end

  def update_season
    logger.info "Updating #{LEAGUE_ABBR} season #{@season.short_name}"
    games = bball_ref_games @season

    # TODO: fail if bballref has a  diff amount if incomplete games than i do
    # TODO: quit when there are no games left
    logger.info "Checking #{games.count} of #{@season.incomplete_games.count} incomplete games"
    update_games_in_transaction games
  end

  def update_games_in_transaction(games_json)
    ActiveRecord::Base.transaction do
      logger.info "Starting status: #{status_str}"
      update_games games_json
      validate_season
      logger.info "Ending status: #{status_str}"
    end
  end

  def update_games(games_json)
    games_json.each_with_index do |game_json, i|
      if (game = get_game(game_json)).nil?
        logger.warn "Game not found in the DB as is. Looking for one with a different time. game=[#{game_json}"
        handle_missing_game game_json, games_json
      else
        update_game game, game_json
      end
      log_on_200th(i + 1)
    end
  end

  def handle_missing_game(single_game_info, all_game_info)
    home = get_team single_game_info[:home]
    away = get_team single_game_info[:away]
    orphan_game = get_orphaned_match_up home, away, all_game_info
    logger.warn "Updating both the score and time for #{orphan_game.to_string}"
    update_game orphan_game, single_game_info, true
    orphan_game.reload
    logger.warn "Updated game to: #{orphan_game.to_string}"
  end

  def get_orphaned_match_up(home, away, all_game_info)
    match_ups = @season.games_against home, away
    orphan_games = match_ups.reject { |m| game_in_bball_ref? m, all_game_info }
    unless orphan_games.count == 1
      # Two scenarios can lead to here:
      # 1. two games between the same two teams had there gametimes moved since the last update. This results in two
      #    orphans. In that scenario, I do not know which is which and thus don't know which one to update.
      # 2. If there are no orphans, I have no game to update. This scenario should never happen because it should've
      #    been found via get_game.
      # Either way, throw an error.
      orphan_string = orphan_games.collect(&:to_string)
      fail "Incorrect num of orphans found (#{orphan_games.count} for #{single_game_info}: #{orphan_string}"
    end
    orphan_games.first
  end

  def update_game(game, game_info, update_time = false)
    game.update home_score: game_info[:home][:score], away_score: game_info[:away][:score]
    game.update time: game_info[:time] if update_time
  end

  def log_on_200th(i)
    return unless i % 200 == 0
    logger.info "  #{i} games processed"
    logger.info "  Status: #{status_str}"
  end

  def status_str
    "#{@season.games.count} games & #{@season.teams.count} teams"
  end

  def validate_season
    Exceptions::TooManyGamesException.raise_if @season.games.count
    Exceptions::TooManyTeamsException.raise_if @season.teams.count
  end

  def get_season(name, short_name)
    season = Season.find_by name: name, short_name: short_name, league: @league
    fail "Season(name: #{name}, short_name: #{short_name}) does not exist" unless season
    season
  end

  def get_team(team_info)
    team = @season.teams.find_by name: team_info[:name], abbr: team_info[:abbr]
    unless team
      fail "Team(name: #{team_info[:name]}, abbr: #{team_info[:abbr]}, season: #{@season.short_name}) does not exist"
    end
    team
  end

  def get_game(game_json)
    home = get_team game_json[:home]
    away = get_team game_json[:away]
    time = game_json[:time]
    game = @season.game_class.find_by(home: home, away: away, time: time)
    game
  end
end
