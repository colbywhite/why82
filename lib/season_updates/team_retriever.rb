module SeasonUpdates
  class TeamRetriever
    def initialize(season)
      @season = season
    end

    def team(team_hash)
      team = @season.teams.find_by name: team_hash[:name], abbr: team_hash[:abbr]
      unless team
        fail "Team(name: #{team_hash[:name]}, abbr: #{team_hash[:abbr]}, season: #{@season.short_name}) does not exist"
      end
      team
    end
  end
end
