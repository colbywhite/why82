module SeasonUpdates
  module Utils
    def game_in_third_party_list?(game, third_party_games)
      found = third_party_games.select { |g| info_represents_game? g, game }
      !found.empty?
    end

    def info_represents_game?(game_info, game)
      info_contains_team?(game_info, game.home, :home) &&
        info_contains_team?(game_info, game.away, :away) &&
        game_info[:time] == game.time
    end

    def info_contains_team?(game_info, team, team_type)
      game_info[team_type][:abbr] == team.abbr && game_info[team_type][:name] == team.name
    end
  end
end
