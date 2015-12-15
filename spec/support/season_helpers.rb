module SeasonHelpers
  ##
  # This will set up the db with the following:
  # - a NBA league
  # - a 2015 NBA season
  # - the 30 NBA teams from the 2015 season
  def setup_2015_season
    setup_season 'Test', '2015'
  end

  ##
  # This will set up the db with the following:
  # - a NBA league
  # - a season with the given name/short_name
  # - the 30 NBA teams from the 2015 season
  def setup_season(name, short_name)
    nba = create :league, name: SeasonUpdates::Updater::LEAGUE_NAME, abbr: SeasonUpdates::Updater::LEAGUE_ABBR
    nba2015 = create :season, name: name, short_name: short_name, league: nba
    teams_file = 'spec/resources/2015/teams.json'
    teams = JSON.parse File.read(teams_file), symbolize_names: true
    teams.each { |team| create_team_in_season nba2015, team }
    nba2015
  end

  ##
  # This sets up the db as if the 2015-10-29 games were just played.
  # This means all Oct. games have been played except for the last two days.
  def setup_oct_29_2015_games(nba2015 = nil)
    nba2015 = setup_2015_season unless nba2015
    games_file = 'spec/resources/2015/20151029_games.json'
    games = JSON.parse File.read(games_file), symbolize_names: true
    games.each do |game|
      game[:home] = nba2015.teams.find_by game[:home]
      game[:away] = nba2015.teams.find_by game[:away]
      create_game_in_season nba2015, game
    end
  end

  def create_team_in_season(season, team_details = {})
    team = create(:team, team_details)
    team.seasons += [season]
    team
  end

  def create_game_in_season(season, game_details = {})
    season_sym = season_to_game_sym season
    create season_sym, game_details
  end

  def create_n_offsetted_games_in_season(season, num_games, game_details = {}, offset = 1.week)
    game_details[:time] ||= Time.zone.now
    (0..num_games - 1).collect do |n|
      game_details[:time] = game_details[:time] + (offset * n)
      create_game_in_season season, game_details
    end
  end
end

RSpec.configure do |c|
  c.include SeasonHelpers
end
