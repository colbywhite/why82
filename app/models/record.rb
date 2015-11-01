module Record
  def empty_record(team_id)
    Object.const_get(self.name).new team_id: team_id, wins: 0, losses: 0, ties: 0, percentage: 0.0
  end

  def total_games
    wins + losses + ties
  end
end