# A test metric that tiers teams based on total wins
module Metrics
  class TotalWins < Metric
    def tier_one
      teams_with_num_wins(2).collect(&collect_with)
    end

    def tier_two
      teams_with_num_wins(1).collect(&collect_with)
    end

    def tier_three
      teams_with_num_wins(0).collect(&collect_with)
    end

    private

    def teams_with_num_wins(num_wins)
      season.teams.select { |t| t.record(season).wins == num_wins }
    end
  end
end
