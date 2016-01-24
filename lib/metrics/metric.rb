module Metrics
  class Metric
    attr_reader :season
    attr_reader :collect_with

    def initialize(season)
      @season = season
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
  end
end
