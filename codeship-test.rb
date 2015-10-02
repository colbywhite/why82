#!/usr/bin/env ruby
require 'rake'

sh 'bundle exec rubocop'
sh({ 'RAILS_ENV' => 'test' }, 'bundle exec rake spec')
