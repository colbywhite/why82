module Metrics
  class Metric
    attr_reader :season
    attr_reader :collect_with

    def initialize(season, collect_with = default_collector)
      @season = season
      @collect_with = collect_with
    end

    def tier_one
      fail NotImplementedError
    end

    def tier_two
      fail NotImplementedError
    end

    def tier_three
      fail NotImplementedError
    end

    def tiers
      [tier_one,
       tier_two,
       tier_three
      ]
    end

    def named_tiers
      { '1' => tier_one,
        '2' => tier_two,
        '3' => tier_three
      }
    end

    private

    def records
      season.records
    end

    def default_collector
      :team_id
    end
  end
end
