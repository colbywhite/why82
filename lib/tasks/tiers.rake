namespace :tiers do
  @current_season = nil
  @overall_tiers = nil
  @collect_lambda = ->(t) { t.team.abbr }

  def current_season
    @current_season = Season.find_by short_name: '2016' unless @current_season
    @current_season
  end

  def overall_tiers
    @overall_tiers = Metrics::Calculator.new(current_season).overall_tiers unless @overall_tiers
    @overall_tiers
  end

  def print_teams_in_tier(tier)
    overall_tiers[tier - 1].each do |team|
      puts "  #{team.abbr}"
    end
  end

  def task_name_to_tier(task_name)
    task_name.name.split(':').last.to_i
  end

  def do_tier_task(task_name)
    tier = task_name_to_tier(task_name)
    puts "Tier #{tier}"
    print_teams_in_tier tier
  end

  task '1': :environment do |task_name|
    do_tier_task task_name
  end

  task '2': :environment do |task_name|
    do_tier_task task_name
  end

  task '3': :environment do |task_name|
    do_tier_task task_name
  end

  task one: '1'
  task two: '2'
  task three: '3'
  task all: %w(1 2 3)
end

task 'tiers': 'tiers:all'
