#!/usr/bin/env ruby
require 'rake'

sh 'bundle install --without production'

# codeship overrides the database.yml to use postgres.
# This will set it back to the one in git
# See: https://codeship.com/documentation/databases/postgresql/#ruby-on-rails
sh 'git checkout config/database.yml'
