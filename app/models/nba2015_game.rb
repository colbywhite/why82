class Nba2015Game < ActiveRecord::Base
  extend Game
  include Game
  include GameJsonSerialization
  belongs_to :home, class_name: 'Team', foreign_key: :home_id
  belongs_to :away, class_name: 'Team', foreign_key: :away_id

  self.per_page = Sked::Application.config.games_per_page
end
