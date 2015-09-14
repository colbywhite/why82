class Team < ActiveRecord::Base
  has_many :home_games, :class_name => 'Game', :foreign_key=>:home_id
  has_many :away_games, :class_name => 'Game', :foreign_key=>:away_id

  def games
    Game.by_team self.id
  end

  def logo
    ActionController::Base.helpers.asset_path("logos/#{self.abbr.downcase}.png")
  end
end
