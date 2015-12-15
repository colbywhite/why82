module SeasonUpdates
  module SingleGameUpdater
    def self.update_score(game, game_info)
      game.update home_score: game_info[:home][:score], away_score: game_info[:away][:score]
    end

    def self.update_score_and_time(game, game_info)
      game.update home_score: game_info[:home][:score],
                  away_score: game_info[:away][:score],
                  time: game_info[:time]
    end
  end
end
