module Errors
  class NoTeamFoundError < StandardError
    def initialize(team_info, season)
      super "#{team_to_err_message(team_info)} does not exist for #{season_to_err_message(season)}"
    end

    private

    def team_to_err_message(team_info)
      return 'Team(nil)' if team_info.nil?
      "Team(name: #{team_info[:name]}, abbr: #{team_info[:abbr]})"
    end

    def season_to_err_message(season)
      return 'Season(nil)' if season.nil?
      "Season(#{season.short_name})"
    end
  end

  class ZeroOrMultipleOrphansError < StandardError
    def initialize(orphans, home_team, away_team)
      super orphans_to_err_message(orphans, home_team, away_team)
    end

    private

    def orphans_to_err_message(orphans, home, away)
      orphan_string = orphans.collect(&:to_string)
      "Incorrect num of orphans found (#{orphans.count} for #{away.name}@#{home.name}: #{orphan_string}"
    end
  end

  class NoSeasonFoundError < StandardError
    def initialize(name, short_name, league)
      super build_msg(name, short_name, league)
    end

    def build_msg(name, short_name, league)
      league_str = (league.nil?) ? 'nil' : league.abbr
      name_str = name || 'nil'
      short_name_str = short_name || 'nil'
      "Season(name: #{name_str}, short_name: #{short_name_str}, league: #{league_str}) does not exist"
    end
  end
end
