module SeasonUpdates
  class Seeder
    include BballRef::GameParser
    include AccessRailsLogger

    attr_reader :name, :short_name, :season, :league

    def initialize(name, short_name)
      @name = name
      @short_name = short_name
      @league = League.find_or_create_by name: SeasonUpdates::LEAGUE_NAME,
                                         abbr: SeasonUpdates::LEAGUE_ABBR
    end

    def seed
      @season = Season.find_or_create_by name: name, short_name: short_name,
                                         league: league
      logger.info "Seeding #{season.status_string}"
      seed_season
      logger.info "Finished seeding #{season.status_string}"
      season
    end

    def seed_season
      seed_teams if season.teams.count == 0
      seed_games if season.games.count == 0
    end

    def seed_teams
      teams_info = BballRef::TeamParser.new.third_party_teams season
      logger.info "Found #{teams_info.count} teams for #{season.short_name}"
      teams_info.collect do |t|
        team = Team.find_or_create_by t
        team.seasons += [season]
        team
      end
    end

    def seed_games
      games_info = third_party_games season
      logger.info "Found #{games_info.count} games for #{season.short_name}"
      games_info.each_with_index do |game_info, i|
        Utils::GameCreator.find_or_create game_info, season
        log_on_200th(i + 1)
      end
    end

    def log_on_200th(i)
      return unless i % 200 == 0
      logger.info "  #{i} games processed"
      logger.info "  Season status: #{season.status_string}"
    end
  end
end
