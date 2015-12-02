namespace :nba do
  namespace :seed do
    desc 'Seed the NBA 2015 season into the DB'
    task '2015': :environment do
      UpdateSeason.new('2014-15 NBA Regular Season', '2015').perform
    end

    desc 'Seed the NBA 2016 season into the DB'
    task '2016': :environment do
      UpdateSeason.new('2015-16 NBA Regular Season', '2016').perform
    end
  end

  task seed: %w(nba:seed:2015 nba:seed:2016)

  namespace :tier do
    @current_season = nil
    @collect_lambda = ->(t) { t.team.abbr }

    task '1': :environment do
      teams = TeamFilter::Record.tier_one current_season, @collect_lambda
      Rails.logger.info "Tier 1: #{teams.join ', '}"
    end

    task '2': :environment do
      teams = TeamFilter::Record.tier_two current_season, @collect_lambda
      Rails.logger.info "Tier 2: #{teams.join ', '}"
    end

    task '3': :environment do
      teams = TeamFilter::Record.tier_three current_season, @collect_lambda
      Rails.logger.info "Tier 3: #{teams.join ', '}"
    end

    task one: '1'
    task two: '2'
    task three: '3'

    def current_season
      @current_season = Season.find_by short_name: '2016' unless @current_season
      @current_season
    end
  end

  task tier: %w(tier:1 tier:2 tier:3)
  task tiers: :tier
end
