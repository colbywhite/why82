module SetupHelpers
  # create 15 games, 10 of which involve the given team, 5 home and 5 away
  # TODO: need a more descriptive name for this method
  def create_games_for_team(team)
    # create five random games that do not contain the team
    games = (0..4).collect { create(:game) }
    # create five home games for the team, then five away
    games += (0..4).collect { create(:game, home: team) }
    games += (0..4).collect { create(:game, away: team) }
    games
  end
end

RSpec.configure do |c|
  c.include SetupHelpers
end
