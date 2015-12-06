class Team < ActiveRecord::Base
  has_and_belongs_to_many :seasons

  def games(season)
    season.game_class.by_team(id)
  end

  def record(season)
    record_class = season.record_class
    record = record_class.find_by(team_id: id)
    record = record_class.empty_record id if record.nil?
    record
  end

  def logo
    ActionController::Base.helpers.asset_path("logos/#{abbr.downcase}.png")
  end

  def as_json(opts = {})
    json = super(opts)
    json['record'] = record(opts[:season]).to_string if opts[:season]
    json
  end
end
