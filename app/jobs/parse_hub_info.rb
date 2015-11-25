module ParseHubInfo
  PARSEHUB_API_KEY = Sked::Application.config.parsehub_api_key
  BASE_URL = 'https://www.parsehub.com/api/v2'

  # constants
  RUN_TOKEN = 'run_token'
  STATUS = 'status'
  COMPLETE = 'complete'

  INITIAL_POLL_INTERVAL = Sked::Application.config.initial_poll_interval
  INITIAL_POLL_TIMEOUT = Sked::Application.config.initial_poll_timeout
  SECONDARY_POLL_INTERVAL = Sked::Application.config.secondary_poll_interval
  SECONDARY_POLL_TIMEOUT = Sked::Application.config.secondary_poll_timeout
end
