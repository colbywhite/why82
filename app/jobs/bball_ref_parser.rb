require 'nokogiri'
require 'open-uri'

# module to contain methods related to parsing
# basketball-reference.com
module BballRefParser
  BASE_URL = 'http://www.basketball-reference.com'
  DEFAULT_TZ = ActiveSupport::TimeZone['Eastern Time (US & Canada)']

  def parse_doc(url)
    open(url) do |f|
      Nokogiri::HTML f
    end
  end

  def pull_season_html(season)
    url = "#{BASE_URL}/leagues/NBA_#{season.short_name}_games.html"
    parse_doc(url).xpath "//table[@id='games']/tbody/tr"
  end

  def parse_team_info(html_game, index)
    name = html_game.xpath(".//td[#{index}]").text
    abbr = html_game.xpath(".//td[#{index}]/a/@href")[0].value.split('/')[2]
    score = html_game.xpath(".//td[#{index + 1}]").text
    if score.nil? || score.empty?
      score = nil
    else
      score = score.to_i
    end
    { name: name, abbr: abbr, score: score }
  end

  def parse_game_html(html, _season)
    game_info = {}

    game_info[:time] = parse_time(html)

    # away team's at index 4
    game_info[:away] = parse_team_info html, 4
    # home team's at index 6
    game_info[:home] = parse_team_info html, 6

    game_info[:extra_time] = html.xpath('.//td[8]').text
    game_info
  end

  def parse_time(html)
    # Removes the day of the week from the string (i.e. 'Tue, ')
    date = html.xpath('.//td[1]').text[5..-1]
    time = html.xpath('.//td[2]').text
    Chronic.time_class = DEFAULT_TZ
    Chronic.parse "#{date} #{time}"
  end

  def create_team(name, abbr, season)
    team = Team.find_or_create_by(name: name, abbr: abbr)
    team.seasons += [season]
    team
  end
end
