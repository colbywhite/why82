class Game < ActiveRecord::Base
  belongs_to :home, :class_name => 'Team', :foreign_key=>:home_id
  belongs_to :away, :class_name => 'Team', :foreign_key=>:away_id

  def self.by_team(team_id)
    where('home_id = :team_id OR away_id = :team_id', team_id: team_id)
  end
end
