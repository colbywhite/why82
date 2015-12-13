module SeasonHelpers
  ##
  # This will set up the db with the following:
  # - a NBA league
  # - a 2015 NBA season
  # - 30 NBA teams for the 2015 season
  def setup_2015_season
    nba = create :league, name: UpdateSeason::LEAGUE_NAME, abbr: UpdateSeason::LEAGUE_ABBR
    nba2015 = create :season, name: 'Test', short_name: '2015', league: nba
    teams_file = 'spec/resources/2015/teams.json'
    teams = JSON.parse File.read(teams_file), symbolize_names: true
    teams.each do |team|
      t = create(:team, team)
      t.seasons += [nba2015]
    end
    nba2015
  end

  ##
  # This sets up the db as if the 2015-10-29 games were just played.
  # This means all Oct. games have been played except for the last two days.
  def setup_oct_29_2015_games
    nba2015 = setup_2015_season
    nba2015game = season_to_game_sym nba2015
    games_file = 'spec/resources/2015/20151029_games.json'
    games = JSON.parse File.read(games_file), symbolize_names: true
    games.each do |game|
      game[:home] = nba2015.teams.find_by game[:home]
      game[:away] = nba2015.teams.find_by game[:away]
      create nba2015game, game
    end
  end
end

RSpec.configure do |c|
  c.include SeasonHelpers
end
