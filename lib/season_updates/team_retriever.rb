module SeasonUpdates
  class TeamRetriever
    def initialize(season)
      @season = season
    end

    def team(team_info)
      team = @season.teams.find_by name: team_info[:name], abbr: team_info[:abbr]
      fail Errors::NoTeamFoundError.new team_info, @season unless team
      team
    end
  end
end
