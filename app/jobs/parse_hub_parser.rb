# module to contain methods related to parsing custom APIs that have been built
# via parsehub.com. Every season will have parsehub project that has been
# created for it
module ParseHubParser
  PARSEHUB_API_KEY = Sked::Application.config.parsehub_api_key
  BASE_URL = 'https://www.parsehub.com/api/v2'
  SEASON_PROJECTS = { '2015' => 'tx4aJc83Ap-7hlfh0IsUgEP8',
                      '2016' => 'tc6QcxGUigYpEELchlkmh3_8' }
  DEFAULT_TZ = ActiveSupport::TimeZone['Eastern Time (US & Canada)']

  HOME = 'home'
  HOME_ABBR = 'home_abbr'
  HOME_SCORE = 'home_score'
  AWAY = 'away'
  AWAY_ABBR = 'away_abbr'
  AWAY_SCORE = 'away_score'
  EASTERN_DATE = 'eastern_date'
  EASTERN_TIME = 'eastern_time'

  def pull_season_json(season)
    url = season_url season
    JSON.parse(RestClient.get(url).to_s)['games']
  end

  def season_url(season)
    project = SEASON_PROJECTS[season.short_name]
    fail "No project found for season #{season.short_name}" if project.nil?
    url = "#{BASE_URL}/projects/#{project}/last_ready_run/data"
    "#{url}?api_key=#{PARSEHUB_API_KEY}"
  end

  def build_time(game_json)
    # Removes the day of the week from the string (i.e. 'Tue, ')
    date = game_json[EASTERN_DATE][5..-1]
    time = game_json[EASTERN_TIME]
    Chronic.time_class = DEFAULT_TZ
    Chronic.parse "#{date} #{time}"
  end
end
