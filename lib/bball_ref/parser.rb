# module to contain methods related to parsing
# basketball-reference.com
module BballRef
  module Parser
    BASE_URL = 'http://www.basketball-reference.com'
    DEFAULT_TZ = ActiveSupport::TimeZone['Eastern Time (US & Canada)']

    def bball_ref_games(season)
      # TODO: fail if there are no incomplete games
      start_date = season.incomplete_games.order(:time).first.time.beginning_of_day
      logger.info "Looking for games after #{start_date}"
      pull_season_html(season.short_name, start_date).collect do |html|
        parse_game_html html
      end
    end

    def parse_doc(url)
      open(url) do |f|
        Nokogiri::HTML f
      end
    end

    def pull_season_html(short_name, start_date = nil)
      url = season_url short_name
      if start_date
        date_string = start_date.strftime '%a, %b %d, %Y'
        # rubocop:disable Metrics/LineLength
        xpath = "//table[@id='games']/tbody/tr[not(.//th) and ./td[contains(.,'#{date_string}')]][1]/preceding-sibling::tr[1]/following-sibling::tr[not(.//th)]"
        # rubocop:enable Metrics/LineLength
      else
        xpath = "//table[@id='games']/tbody/tr[not(.//th)]"
      end
      parse_doc(url).xpath xpath
    end

    def season_url(short_name)
      "#{BASE_URL}/leagues/NBA_#{short_name}_games.html"
    end

    def parse_team_info(html_game, index)
      name = parse_clean_text html_game, ".//td[#{index}]"
      abbr = html_game.xpath(".//td[#{index}]/a/@href")[0].value.split('/')[2]
      score = parse_clean_text html_game, ".//td[#{index + 1}]"
      if score.nil? || score.empty?
        score = nil
      else
        score = score.to_i
      end
      { name: name, abbr: abbr, score: score }
    end

    def parse_game_html(html)
      game_info = {}

      game_info[:time] = parse_time(html)

      # away team's at index 4
      game_info[:away] = parse_team_info html, 4
      # home team's at index 6
      game_info[:home] = parse_team_info html, 6

      game_info[:extra_time] = parse_clean_text html, './/td[8]'
      game_info
    end

    def parse_time(html)
      # Removes the day of the week from the string (i.e. 'Tue, ')
      date = parse_clean_text(html, './/td[1]')[5..-1]
      time = parse_clean_text html, './/td[2]'
      Chronic.time_class = DEFAULT_TZ
      Chronic.parse "#{date} #{time}"
    end

    def parse_clean_text(html, xpath_str)
      html.xpath(xpath_str).text.strip.gsub(/\s+/, ' ')
    end
  end
end
