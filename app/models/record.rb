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

  def percentage_string
    format('%.3f', percentage.truncate(3))
  end

  # Note: overriding to_s method in an ActiveRecord class breaks rails. Hence why this is to_string.
  # https://rails.lighthouseapp.com/projects/8994/tickets/2742-class-method-to_s-used-instead-of-name
  def to_string(hide_ties = true)
    if hide_ties
      "#{wins}-#{losses} (#{percentage_string})"
    else
      "#{wins}-#{losses}-#{ties} (#{percentage_string})"
    end
  end
end
