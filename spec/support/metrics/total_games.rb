# A test metric that tiers teams based on total wins
module Metrics
  class TotalGames < Metric
    def tier_one
      total_games_equals(3).collect(&collect_with)
    end

    def tier_two
      total_games_equals(2).collect(&collect_with)
    end

    def tier_three
      total_games_equals(1).collect(&collect_with)
    end

    private

    def total_games_equals(num_gams)
      season.teams.select { |t| t.games(season).count(:all) == num_gams }
    end
  end
end
