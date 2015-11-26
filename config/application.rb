require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sked
  class Application < Rails::Application
    # Settings in config/environments/* take precedence
    #   over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record
    #   auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    #   Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from
    #   config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path +=
    #   Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths << Rails.root.join('lib')

    # rubocop:disable Metrics/LineLength
    # compile bower assets
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components', 'bootstrap-sass-official', 'assets', 'fonts')
    # rubocop:enable Metrics/LineLength

    config.assets.precompile << /.*.(?:eot|svg|ttf|woff)$/
    config.games_per_page = 100
    config.active_record.schema_format = :sql
    config.parsehub_api_key = ENV['PARSEHUB_API_KEY']
    config.max_games_in_season = 1230
    config.max_teams_in_season = 30

    # 15 seconds
    config.initial_poll_interval = 15
    # 5 minutes
    config.initial_poll_timeout = 5 * 60
    # 3.5 minutes
    config.secondary_poll_interval = (3 * 60) + 30
    # 25 minutes
    config.secondary_poll_timeout = 25 * 60
  end
end
