class Team < ActiveRecord::Base
  include JsonSerializable
  has_and_belongs_to_many :seasons

  DEFAULT_JSON_OPTS = BASE_JSON_OPTS.merge methods: :logo

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
    json = super DEFAULT_JSON_OPTS.merge(opts)
    json['record'] = record(opts[:season_for_record]).to_string if opts[:season_for_record]
    json
  end
end
