#!/usr/bin/env ruby
require 'rake'

sh({'RAILS_ENV'=>'test'}, 'bundle exec rake db:reseed')
sh({'RAILS_ENV'=>'test'}, 'bundle exec rake test')
