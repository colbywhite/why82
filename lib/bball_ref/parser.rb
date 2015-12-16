# module to contain methods related to parsing
# basketball-reference.com
module BballRef
  module Parser
    BASE_URL = 'http://www.basketball-reference.com'
    DEFAULT_TZ = ActiveSupport::TimeZone['Eastern Time (US & Canada)']

    ##
    # Returns a season worth of incomplete games from a third party. In this case
    # the third party is BballRef. The games are returned in Hash form.
    # An example is:
    # [
    #   {
    #     :time=>Thu, 30 Oct 2014 20:00:00 EDT -04:00,
    #     :away=>{
    #       :name=>"New York Knicks",
    #       :abbr=>"NYK",
    #       :score=>95
    #     },
    #     :home=>{
    #       :name=>"Cleveland Cavaliers",
    #       :abbr=>"CLE",
    #       :score=>90
    #     },
    #     :extra_time=>""
    #   },
    #   ...
    # ]
    def third_party_incomplete_games(season)
      # TODO: return nothing if there are no incomplete games
      start_date = season.incomplete_games.order(:time).first.time.beginning_of_day
      logger.info "Looking for games after #{start_date}"
      pull_seasons_game_nodes(season.short_name, start_date).collect do |node|
        game_node_to_hash node
      end
    end

    def parse_doc(url)
      html = RestClient.get(url) { |response| response.to_s }
      Nokogiri::HTML html
    end

    ##
    # Pulls a season's html page and return a Nokogiri::XML::NodeSet where each
    # Nokogiri::XML::Node represents a game.
    def pull_seasons_game_nodes(short_name, start_date = nil)
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
      score = (score.nil? || score.empty?) ? nil : score.to_i
      { name: name, abbr: abbr, score: score }
    end

    ##
    # Converts a Nokogiri::XML::Node to a Hash containing the relevant information
    # representing a Game.
    def game_node_to_hash(node)
      game_info = {}

      game_info[:time] = parse_time node

      # away team's at index 4
      game_info[:away] = parse_team_info node, 4
      # home team's at index 6
      game_info[:home] = parse_team_info node, 6

      game_info[:extra_time] = parse_clean_text node, './/td[8]'
      game_info
    end

    def parse_time(node)
      # Removes the day of the week from the string (i.e. 'Tue, ')
      date = parse_clean_text(node, './/td[1]')[5..-1]
      time = parse_clean_text node, './/td[2]'
      Chronic.time_class = DEFAULT_TZ
      Chronic.parse "#{date} #{time}"
    end

    ##
    # Parses text out of a node while striping out redundant whitespace.
    def parse_clean_text(node, xpath_str)
      node.xpath(xpath_str).text.strip.gsub(/\s+/, ' ')
    end
  end
end
