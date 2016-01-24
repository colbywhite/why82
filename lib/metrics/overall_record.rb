module Metrics
  module OverallRecord
    TIER_ONE_CUTOFF = 0.65
    TIER_TWO_CUTOFF = 0.55

    def self.tier_one(season, collect_with = :team_id)
      select_records(season).at_least(TIER_ONE_CUTOFF).collect(&collect_with)
    end

    def self.tier_two(season, collect_with = :team_id)
      select_records(season).in_between(TIER_ONE_CUTOFF, TIER_TWO_CUTOFF).collect(&collect_with)
    end

    def self.tier_three(season, collect_with = :team_id)
      select_records(season).less_than(TIER_TWO_CUTOFF).collect(&collect_with)
    end

    def self.tiers(season, collect_with = :team_id)
      [tier_one(season, collect_with),
       tier_two(season, collect_with),
       tier_three(season, collect_with)
      ]
    end

    def self.named_tiers(season, collect_with = :team_id)
      { '1' => tier_one(season, collect_with),
        '2' => tier_two(season, collect_with),
        '3' => tier_three(season, collect_with)
      }
    end

    private

    def self.select_records(season)
      season.record_class.select(:team_id)
    end
  end
end
