#!/usr/bin/env ruby
require 'rake'

sh 'bundle install --without production'
sh 'npm install bower -g'
sh 'bundle exec rake bower:install'
