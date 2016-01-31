module Metrics
  class LastTenRecord < Metric
    TIER_ONE_CUTOFF = 8
    TIER_TWO_CUTOFF = 6

    def tier_one
      fetch { |team| team.last_ten_record(season).wins >= TIER_ONE_CUTOFF }
    end

    def tier_two
      fetch do |team|
        wins = team.last_ten_record(season).wins
        wins < TIER_ONE_CUTOFF && wins >= TIER_TWO_CUTOFF
      end
    end

    def tier_three
      fetch { |team| team.last_ten_record(season).wins < TIER_TWO_CUTOFF }
    end

    private

    def fetch
      season.teams.select do |team|
        yield team
      end
    end
  end
end
