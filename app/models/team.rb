class Team < ActiveRecord::Base
  include JsonSerializable
  has_and_belongs_to_many :seasons

  DEFAULT_JSON_OPTS = BASE_JSON_OPTS.deep_dup.merge methods: :logo

  def games(season)
    season.game_class.by_team(id)
  end

  def last_ten_record(season)
    last_n_record season, 10
  end

  def last_n_record(season, limit)
    games = season.last_n_complete self, limit
    wins, losses = calc_wins_losses games
    season.record_class.new team_id: id, wins: wins, losses: losses,
                            ties: 0, percentage: calc_percentage(wins, losses)
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
    json = super DEFAULT_JSON_OPTS.deep_dup.merge(opts)
    json['record'] = record(opts[:season_for_record]).to_string if opts[:season_for_record]
    json
  end

  private

  def calc_wins_losses(games)
    wins = 0
    losses = 0
    games.each do |game|
      wins += 1 if game.winner == self
      losses += 1 if game.loser == self
    end
    [wins, losses]
  end

  def calc_percentage(wins, losses)
    total_games = wins + losses
    (total_games > 0) ? BigDecimal.new(wins) / BigDecimal.new(total_games) : BigDecimal(0)
  end
end
