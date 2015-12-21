namespace :nba do
  namespace :update do
    desc 'Update the NBA 2015 season into the DB'
    task '2015': :environment do
      SeasonUpdates::Updater.new('2014-15 NBA Regular Season', '2015').perform
    end

    desc 'Update the NBA 2016 season into the DB'
    task '2016': :environment do
      SeasonUpdates::Updater.new('2015-16 NBA Regular Season', '2016').perform
    end
  end

  task update: %w(nba:update:2016)

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

  namespace :seed do
    task '2016': :environment do
      name = '2015-16 NBA Regular Season'
      short_name = '2016'
      SeasonUpdates::Seeder.new(name, short_name).safe_seed
    end
    task '2015': :environment do
      name = '2014-15 NBA Regular Season'
      short_name = '2015'
      SeasonUpdates::Seeder.new(name, short_name).safe_seed
    end
  end

  task seed: 'nba:seed:2016'
end
