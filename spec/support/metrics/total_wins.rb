# A test metric that tiers teams based on total wins
module Metrics
  module TotalWins
    def self.tier_one(season, collect_with = :id)
      teams_with_num_wins(season, 2).collect(&collect_with)
    end

    def self.tier_two(season, collect_with = :id)
      teams_with_num_wins(season, 1).collect(&collect_with)
    end

    def self.tier_three(season, collect_with = :id)
      teams_with_num_wins(season, 0).collect(&collect_with)
    end

    def self.tiers(season, collect_with = :id)
      [tier_one(season, collect_with),
       tier_two(season, collect_with),
       tier_three(season, collect_with)
      ]
    end

    def self.named_tiers(season, collect_with = :id)
      { '1' => tier_one(season, collect_with),
        '2' => tier_two(season, collect_with),
        '3' => tier_three(season, collect_with)
      }
    end

    private

    def self.teams_with_num_wins(season, num_wins)
      season.teams.select { |t| t.record(season).wins == num_wins }
    end
  end
end
