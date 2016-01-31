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
