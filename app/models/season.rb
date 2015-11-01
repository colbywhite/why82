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

  def record_class
    league = 'nba'
    Object.const_get "#{league.camelcase}#{short_name.camelcase}Record"
  end

  def records
    record_class.all
  end

  def teams
    homes = game_class.select('home_id as id').group(:home_id)
    aways = game_class.select('away_id as id').group(:away_id)
    unique_ids = (homes | aways).collect(&:id)
    Team.find(unique_ids)
  end
end
