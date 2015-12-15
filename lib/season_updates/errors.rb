module SeasonUpdates
  module Errors
    class NoTeamFoundError < StandardError
      def initialize(team_hash, season)
        super "#{team_to_err_message(team_hash)} does not exist for #{season_to_err_message(season)}"
      end

      private

      def team_to_err_message(team_hash)
        return 'Team(nil)' if team_hash.nil?
        "Team(name: #{team_hash[:name]}, abbr: #{team_hash[:abbr]})"
      end

      def season_to_err_message(season)
        return 'Season(nil)' if season.nil?
        "Season(#{season.short_name})"
      end
    end
  end
end
