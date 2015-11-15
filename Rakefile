require File.expand_path('../config/application', __FILE__)
require 'rake/version_task'

Rails.application.load_tasks
Rake::VersionTask.new do |task|
  task.with_git = false
end

namespace :db do
  task count: :environment do
    puts "There are #{Season.count} seasons in the DB"
    season_2016 = Season.find_by short_name: '2016'
    puts "There are #{season_2016.games.count} games in the DB for 2016"
    puts "There are #{season_2016.teams.count} games in the DB for 2016"
  end
end

task :test_db_setup do
  Rails.env = ENV['RAILS_ENV'] = 'test'
  puts 'Dropping test DB'
  Rake::Task['db:drop'].invoke
end

task spec: [:test_db_setup, 'db:create']

task log: :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
