# A test metric that tiers teams based on total wins
module Metrics
  module TotalGames
    def self.tier_one(season, collect_with = :id)
      total_games_equals(season, 3).collect(&collect_with)
    end

    def self.tier_two(season, collect_with = :id)
      total_games_equals(season, 2).collect(&collect_with)
    end

    def self.tier_three(season, collect_with = :id)
      total_games_equals(season, 1).collect(&collect_with)
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

    def self.total_games_equals(season, num_gams)
      season.teams.select { |t| t.games(season).count(:all) == num_gams }
    end
  end
end
