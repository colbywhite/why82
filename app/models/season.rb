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

  def incomplete_games
    games.where(home_score: nil, away_score: nil)
  end

  # rubocop doesn't understand the squeel syntax at all
  # rubocop:disable BlockEndNewline, NonNilCheck
  # rubocop:disable MultilineOperationIndentation, MultilineBlockLayout
  # rubocop:disable BlockDelimiters
  def complete_games
    games.where { (home_score != nil) &
        (away_score != nil) }
  end
  # rubocop:enable BlockEndNewline, NonNilCheck
  # rubocop:enable MultilineOperationIndentation, MultilineBlockLayout
  # rubocop:enable BlockDelimiters

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
end
