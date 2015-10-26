module Game
  def by_team(team_id)
    where('home_id = :team_id OR away_id = :team_id', team_id: team_id)
  end

  def eager_load_teams
    eager_load(:home).eager_load(:away)
  end
end
