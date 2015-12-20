# module to contain methods related to parsing teams from
# basketball-reference.com
module BballRef
  class TeamParser
    include BballRef::Parser

    def team_url(short_name)
      "#{BballRef::BASE_URL}/leagues/NBA_#{short_name}.html"
    end

    def third_party_teams(season)
      pull_team_nodes(season.short_name).map(&method(:team_node_to_hash))
    end

    def team_node_to_hash(node)
      team_info = {}
      team_info[:name] = parse_clean_text node, './/td[2]/a'
      team_info[:abbr] = parse_clean_text(node, './/td[2]/a/@href').split('/')[2]
      team_info
    end

    def pull_team_nodes(short_name)
      url = team_url short_name
      xpath = "(//table[@id='team']/tbody/tr)[position() < last()]"
      parse_doc(url).xpath(xpath)
    end
  end
end
