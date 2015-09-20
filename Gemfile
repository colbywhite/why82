source 'https://rubygems.org'

ruby '2.2.0'
gem 'rails', '4.2.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'bower-rails', '~> 0.10.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'foreman', '~> 0.78.0'
gem 'seed_migration'
gem 'squeel'
gem 'angular-rails-templates'
gem 'jquery-rails'
gem 'font-awesome-sass'
gem 'local_time'
gem 'will_paginate'

gem 'sqlite3', group: [:development, :test]
group :development, :test do
  # Call 'byebug' anywhere in the code to stop
  #   execution and get a debugger console
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application
  #   running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rubocop', require: false
end

group :production do
  gem 'rails_12factor'
  gem 'pg'
end
