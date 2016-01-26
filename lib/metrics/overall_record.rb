module Metrics
  class OverallRecord < Metric
    TIER_ONE_CUTOFF = 0.65
    TIER_TWO_CUTOFF = 0.55

    def tier_one
      records.at_least(TIER_ONE_CUTOFF).collect(&:team)
    end

    def tier_two
      records.in_between(TIER_ONE_CUTOFF, TIER_TWO_CUTOFF).collect(&:team)
    end

    def tier_three
      records.less_than(TIER_TWO_CUTOFF).collect(&:team)
    end

    private

    def records
      season.records
    end
  end
end
