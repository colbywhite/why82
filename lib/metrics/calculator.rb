module Metrics
  class Calculator
    OVERALL_TIER_ONE_MAX = 5.0 / 3 # 1.666
    OVERALL_TIER_TWO_MAX = 7.0 / 3 # 2.333

    attr_reader :season

    def initialize(season)
      @season = season
    end

    def self.weight_config
      Rails.application.config_for(:metrics)['metrics']
    end

    def metric_configs
      Calculator.weight_config.collect do |metric_config|
        metric_class = Object.const_get(metric_config['name'])
        { tiers: metric_class.new(season).tiers,
          weight: metric_config['weight'],
          metric: metric_class
        }
      end
    end

    # @return an Array of size three. Each element is an Array of Team. The first element is the teams with an overall
    # tier of 1, the second have an overall of 2, etc, etc.
    def overall_tiers
      averages = calculate_averages
      overall = []
      overall.push averages.select { |_k, v| v <= OVERALL_TIER_ONE_MAX }.keys
      overall.push averages.select { |_k, v| v > OVERALL_TIER_ONE_MAX && v <= OVERALL_TIER_TWO_MAX }.keys
      overall.push averages.select { |_k, v| v > OVERALL_TIER_TWO_MAX }.keys
      overall
    end

    # @return a Hash where the keys are Team and the values are decimal averages for a team based on the given metrics
    def calculate_averages
      metrics, total_weight = calculate_metrics
      teams = season.teams
      averages = teams.collect do |team|
        1.0 * weighted_sum(metrics, team) / total_weight
      end
      Hash[teams.zip averages].sort_by { |_team, avg| avg }.to_h
    end

    def weighted_sum(metrics, team)
      # for each metric, find which tier the team is and add it to the sum while factoring in the weight
      metrics.sum do |metric|
        tier = get_teams_tier metric[:tiers], team
        tier * metric[:weight]
      end
    end

    def calculate_metrics
      metrics = metric_configs
      total_weight = metrics.sum { |m| m[:weight] }
      [metrics, total_weight]
    end

    def get_teams_tier(tiers, team)
      index = tiers.find_index { |values| values.include? team }
      index + 1
    end
  end
end
