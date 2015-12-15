module SeasonUpdates
  module Utils
    def game_in_bball_ref?(game, bball_ref_games)
      home = game.home
      away = game.away
      found = bball_ref_games.select { |g| equals_bball_ref_game? g, home, away, game.time }
      !found.empty?
    end

    def equals_bball_ref_game?(bball_ref_game, home, away, gametime)
      equals_bball_ref_team?(bball_ref_game, home, :home) &&
        equals_bball_ref_team?(bball_ref_game, away, :away) &&
        bball_ref_game[:time] == gametime
    end

    def equals_bball_ref_team?(bball_ref_game, team, type)
      bball_ref_game[type][:abbr] == team.abbr && bball_ref_game[type][:name] == team.name
    end
  end
end
