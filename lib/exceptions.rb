module Exceptions
  class TooManyGamesException < StandardError
    MAX_GAMES_IN_SEASON = 1230

    def initialize(num_games)
      super("Too many games detected (#{num_games} > #{MAX_GAMES_IN_SEASON})")
    end

    def self.raise_if(num_games)
      if num_games > MAX_GAMES_IN_SEASON
        fail Exceptions::TooManyGamesException, num_games
      end
    end
  end

  class TooManyTeamsException < StandardError
    MAX_TEAMS_IN_SEASON = 30

    def initialize(num_teams)
      super("Too many teams detected (#{num_teams} > #{MAX_TEAMS_IN_SEASON})")
    end

    def self.raise_if(num_teams)
      if num_teams > MAX_TEAMS_IN_SEASON
        fail Exceptions::TooManyTeamsException, num_teams
      end
    end
  end
end
