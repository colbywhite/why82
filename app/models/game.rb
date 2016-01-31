module Game
  def by_team(team_id)
    where('home_id = :team_id OR away_id = :team_id', team_id: team_id)
  end

  def eager_load_teams
    eager_load(:home).eager_load(:away)
  end

  def inbetween_times(start_time, end_time)
    order(:time).where { (time >= start_time) & (time <= end_time) }
  end

  # returns all games where a team from list_one is facing a team from list_two
  def between_lists(list_one, list_two)
    where { ((home_id >> list_one) | (away_id >> list_one)) & ((home_id >> list_two) | (away_id >> list_two)) }
  end

  # returns all games that include at least one of the teams in the list
  def include_any_team(teams)
    where { (home_id >> teams) | away_id >> teams }
  end

  # returns all games where both teams are in the list
  def between_any_team(teams)
    where { (home_id >> teams) & (away_id >> teams) }
  end

  def to_string
    "#{time}: #{away.name} @ #{home.name}"
  end

  def complete?
    !(home_score.nil? || away_score.nil?)
  end

  def winner
    return nil unless complete?
    if home_score > away_score
      home
    elsif away_score > home_score
      away
    end
  end

  def loser
    calculated_winner = winner
    return nil if calculated_winner.nil?
    return away if calculated_winner == home
    home
  end
end
