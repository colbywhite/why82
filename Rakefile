require File.expand_path('../config/application', __FILE__)
require 'rake/version_task'

Rails.application.load_tasks
Rake::VersionTask.new

namespace :db do
  task reseed: %w(db:drop db:create db:migrate seed:migrate db:count)

  task count: :environment do
    puts "There are #{Team.count} teams in the DB"
    puts "There are #{Game.count} games in the DB"
  end
end
