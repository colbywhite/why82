class Season < ActiveRecord::Base
  has_and_belongs_to_many :teams
  belongs_to :league

  def game_class
    league = 'nba'
    Object.const_get "#{league.camelcase}#{short_name.camelcase}Game"
  end

  def games
    game_class.all
  end

  def games_against(home_team, away_team)
    games.joins(:away).where(away: away_team, home: home_team)
  end

  def games_between_lists(start_time, end_time, list_one, list_two)
    games.eager_load_teams.inbetween_times(start_time, end_time).between_lists list_one, list_two
  end

  def games_including_any_team(start_time, end_time, teams)
    games.eager_load_teams.inbetween_times(start_time, end_time).include_any_team teams
  end

  def games_between_any_team(start_time, end_time, teams)
    games.eager_load_teams.inbetween_times(start_time, end_time).between_any_team teams
  end

  def incomplete_games
    games.where(home_score: nil, away_score: nil)
  end

  # rubocop:disable NonNilCheck
  def complete_games
    games.where { (home_score != nil) & (away_score != nil) }
  end
  # rubocop:enable NonNilCheck

  def last_complete_game
    complete_games.order(:time).last
  end

  def first_incomplete_game
    incomplete_games.order(:time).first
  end

  def record_class
    league = 'nba'
    Object.const_get "#{league.camelcase}#{short_name.camelcase}Record"
  end

  def records
    record_class.all
  end

  def teams
    Team.joins(:seasons).where(seasons: { id: id })
  end

  def last_updated_game
    game_class.order(:updated_at).last
  end
end
