module SeasonUpdates
  class Updater
    include SeasonUpdates::SingleGameUpdater
    include BballRef::Parser
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
      games = third_party_incomplete_games @season

      # TODO: fail if bballref has a diff amount of incomplete games than the db
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
          SeasonUpdates::OrphanUpdater.new(@season).update game_json, games_json
        else
          SeasonUpdates::SingleGameUpdater.update_score game, game_json
        end
        log_on_200th(i + 1)
      end
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
      fail Errors::NoSeasonFoundError.new(name, short_name, @league) unless season
      season
    end

    def get_game(game_json)
      home = SeasonUpdates::TeamRetriever.new(@season).team game_json[:home]
      away = SeasonUpdates::TeamRetriever.new(@season).team game_json[:away]
      time = game_json[:time]
      game = @season.game_class.find_by home: home, away: away, time: time
      game
    end
  end
end
