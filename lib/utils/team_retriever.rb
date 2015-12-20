module Utils
  class TeamRetriever
    def initialize(season)
      @season = season
    end

    def team(team_info)
      team = @season.teams.find_by name: team_info[:name], abbr: team_info[:abbr]
      fail Errors::NoTeamFoundError.new team_info, @season unless team
      team
    end

    def self.team(team_info, season)
      Utils::TeamRetriever.new(season).team(team_info)
    end
  end
end
