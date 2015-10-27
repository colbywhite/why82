module SetupHelpers
  # create 15 games, 10 of which involve the given team, 5 home and 5 away
  # TODO: need a more descriptive name for this method
  def create_games_for_team(team, season = nil)
    season = create(:season) unless season
    game_sym = season.game_class.name.underscore.to_sym
    # create five random games that do not contain the team
    games = (0..4).collect { create(game_sym) }
    # create five home games for the team, then five away
    games += (0..4).collect { create(game_sym, home: team) }
    games += (0..4).collect { create(game_sym, away: team) }
    games
  end
end

RSpec.configure do |c|
  c.include SetupHelpers
end
