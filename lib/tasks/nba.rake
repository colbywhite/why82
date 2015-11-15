namespace :nba do
  namespace :seed do
    desc 'Seed the NBA 2015 season into the DB'
    task :'2015' => :environment do
      LoadNbaSeasonJob.perform_later '2014-15 NBA Regular Season', '2015'
    end

    desc 'Seed the NBA 2016 season into the DB'
    task :'2016' => :environment do
      LoadNbaSeasonJob.perform_later '2015-16 NBA Regular Season', '2016'
    end
  end

  task seed: %w(nba:seed:2015 nba:seed:2016)
end