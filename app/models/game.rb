class Game < ActiveRecord::Base
  belongs_to :home, :class_name => 'Team', :foreign_key => :home_id
  belongs_to :away, :class_name => 'Team', :foreign_key => :away_id

  def self.by_team(team_id)
    where('home_id = :team_id OR away_id = :team_id', team_id: team_id)
  end

  def self.eager_load_teams
    self.eager_load(:home).eager_load(:away)
  end
end
