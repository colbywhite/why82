module SeasonUpdates
  class TeamRetriever
    def initialize(season)
      @season = season
    end

    def team(team_hash)
      team = @season.teams.find_by name: team_hash[:name], abbr: team_hash[:abbr]
      fail SeasonUpdates::Errors::NoTeamFoundError.new team_hash, @season unless team
      team
    end
  end
end
