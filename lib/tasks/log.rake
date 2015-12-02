namespace :log do
  namespace :db do
    task info: :environment do
      ActiveRecord::Base.logger.level = 1
    end

    task debug: :environment do
      ActiveRecord::Base.logger.level = 0
    end
  end

  task stdout: :environment do
    Rails.logger = Logger.new STDOUT
  end
end
