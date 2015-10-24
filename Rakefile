require File.expand_path('../config/application', __FILE__)
require 'rake/version_task'

Rails.application.load_tasks
Rake::VersionTask.new do |task|
  task.with_git = false
end

namespace :db do
  task count: :environment do
    puts "There are #{Team.count} teams in the DB"
    puts "There are #{Game.count} games in the DB"
  end
end

task :test_db_setup do
  Rails.env = ENV['RAILS_ENV'] = 'test'
  puts 'Dropping test DB'
  Rake::Task['db:drop'].invoke
end

task spec: :test_db_setup
