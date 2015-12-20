module Utils
  class GameCreator
    def initialize(season)
      @season = season
    end

    def create(game_info)
      prepped_info = prep_info game_info
      @season.game_class.create prepped_info
    end

    def find_or_create(game_info)
      prepped_info = prep_info game_info
      @season.game_class.find_or_create_by prepped_info
    end

    def prep_info(game_info)
      team_retriever = Utils::TeamRetriever.new @season
      prepped = { time: game_info[:time] }
      prepped[:home] = team_retriever.team game_info[:home]
      prepped[:away] = team_retriever.team game_info[:away]
      prepped
    end

    def self.create(game_info, season)
      Utils::GameCreator.new(season).create(game_info)
    end

    def self.find_or_create(game_info, season)
      Utils::GameCreator.new(season).find_or_create(game_info)
    end
  end
end
