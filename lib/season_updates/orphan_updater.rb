module SeasonUpdates
  class OrphanUpdater
    include SeasonUpdates::OrphanUtils
    include AccessRailsLogger

    def initialize(season)
      @season = season
    end

    def update(single_game_info, all_game_info)
      home, away = retrieve_teams single_game_info
      orphan_game = orphaned_match_up home, away, all_game_info
      logger.warn "Updating both the score and time for #{orphan_game.to_string}"
      SingleGameUpdater.update_score_and_time orphan_game, single_game_info
      orphan_game.reload
      logger.warn "Updated game to: #{orphan_game.to_string}"
    end

    def retrieve_teams(game_info)
      team_retriever = Utils::TeamRetriever.new @season
      home = team_retriever.team game_info[:home]
      away = team_retriever.team game_info[:away]
      [home, away]
    end

    def orphaned_match_up(home, away, all_game_info)
      match_ups = @season.games_against home, away
      orphan_games = match_ups.reject { |m| game_in_third_party_list? m, all_game_info }

      # Two scenarios can lead to an error here:
      # 1. two games between the same two teams had their game times moved since the last update. This results in two
      #    orphans. In that scenario, I do not know which is which and thus don't know which one to update.
      # 2. If there are no orphans, I have no game to update. This scenario should never happen because it should've
      #    been found via get_game.
      # Either way, raise an error.
      fail Errors::ZeroOrMultipleOrphansError.new orphan_games, home, away unless orphan_games.count == 1
      orphan_games.first
    end
  end
end
