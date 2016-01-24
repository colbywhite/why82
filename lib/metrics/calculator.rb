module Metrics
  class Calculator
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
        { tiers: metric_class.new(season).named_tiers,
          weight: metric_config['weight'],
          metric: metric_class
        }
      end
    end

    def calculate_tiers
      metrics = metric_configs
      total_weight = metrics.sum { |m| m[:weight] }
      calculate_averages(metrics, total_weight).sort_by { |_k, v| v }.to_h
    end

    def calculate_averages(metrics, total_weight)
      teams = season.teams
      averages = teams.collect do |team|
        # for each metric, find which tier the team is and add it to the sum
        sum = metrics.sum do |metric|
          tier = get_teams_tier metric[:tiers], team
          tier * metric[:weight]
        end
        1.0 * sum / total_weight
      end
      Hash[teams.zip averages]
    end

    def get_teams_tier(tiers, team)
      tiers.select { |_key, value| value.include? team.id }.keys.first.to_i
    end
  end
end
