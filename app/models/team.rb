class Team < ActiveRecord::Base
  has_and_belongs_to_many :seasons

  def games(season)
    season.game_class.by_team(id)
  end

  def record(season)
    season.record_class.find_by(team_id: id)
  end

  def logo
    ActionController::Base.helpers.asset_path("logos/#{abbr.downcase}.png")
  end
end
