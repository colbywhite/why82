module Record
  def empty_record(team_id)
    Object.const_get(name).new team_id: team_id, wins: 0, losses: 0,
                               ties: 0, percentage: 0.0
  end

  def total_games
    wins + losses + ties
  end

  def at_least(percent)
    where { percentage >= percent }
  end

  def less_than(percent)
    where { percentage < percent }
  end

  def in_between(low_end_percent, high_end_percent)
    at_least(high_end_percent).less_than(low_end_percent)
  end
end
