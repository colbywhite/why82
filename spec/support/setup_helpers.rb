module SetupHelpers
  # create 15 games, 10 of which involve the given team, 5 home and 5 away
  # TODO: need a more descriptive name for this method
  def create_games_for_team(team, season = nil)
    season = create(:season) unless season
    game_sym = season_to_game_sym season
    # create five random games that do not contain the team
    games = (0..4).collect { create(game_sym) }
    # create five home games for the team, then five away
    games += (0..4).collect { create(game_sym, home: team) }
    games += (0..4).collect { create(game_sym, away: team) }
    games
  end

  def create_game_with_score(table, home, home_score, away, away_score)
    create(table,
           home: home,
           home_score: home_score,
           away: away,
           away_score: away_score)
  end

  def season_to_game_sym(season)
    season.game_class.name.underscore.to_sym
  end

  def to_bigd(numerator, denominator, decimal_places = 3)
    decimal = BigDecimal.new(numerator.to_s) / BigDecimal.new(denominator.to_s)
    decimal.round(decimal_places)
  end

  def give_team_record(game_table, team, wins, percentage)
    (1..wins).each do
      create_game_with_score(game_table, team, 100,
                             create(:team), 50)
    end
    losses = losses_to_give_percentage wins, percentage
    (1..losses).each do
      create_game_with_score(game_table, team, 50,
                             create(:team), 100)
    end
  end

  def losses_to_give_percentage(wins, desired_percentage)
    if desired_percentage <= 0
      0
    else
      ((wins * (1.0 - desired_percentage)) / desired_percentage).floor
    end
  end

  def create_round_robin_games(game_table, game_date, *teams)
    teams[0..-2].each_with_index do |home, index|
      teams[index + 1..-1].each do |away|
        create(game_table, home: home, away: away, time: game_date)
      end
    end
  end

  ##
  # This will set up the db with the following:
  # - a NBA league
  # - a 2015 NBA season
  # - 30 NBA teams for the 2015 season
  def setup_2015_season
    nba = create(:league, name: UpdateSeason::LEAGUE_NAME, abbr: UpdateSeason::LEAGUE_ABBR)
    nba2015 = create(:season, name: 'Test', short_name: '2015', league: nba)
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
      game[:home] = nba2015.teams.find_by(game[:home])
      game[:away] = nba2015.teams.find_by(game[:away])
      create(nba2015game, game)
    end
  end
end

RSpec.configure do |c|
  c.include SetupHelpers
end
