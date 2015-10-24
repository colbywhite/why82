class Team < ActiveRecord::Base
  has_many :home_games, class_name: 'Game', foreign_key: :home_id
  has_many :away_games, class_name: 'Game', foreign_key: :away_id
  belongs_to :season

  def games
    Game.by_team id
  end

  def logo
    ActionController::Base.helpers.asset_path("logos/#{abbr.downcase}.png")
  end
end
