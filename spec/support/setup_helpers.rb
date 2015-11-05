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

  # rubocop:disable Metrics/AbcSize
  def assert_record_equals(record, wins, losses, ties, percentage)
    expect(record.wins).to eq(wins)
    expect(record.losses).to eq(losses)
    expect(record.ties).to eq(ties)
    expect(record.percentage).to eq(percentage)
    expect(record.total_games).to eq(wins + losses + ties)
  end
  # rubocop:enable Metrics/AbcSize

  def to_bigd(numerator, denominator, decimal_places = 3)
    decimal = BigDecimal.new(numerator.to_s) / BigDecimal.new(denominator.to_s)
    decimal.round(decimal_places)
  end
end

RSpec.configure do |c|
  c.include SetupHelpers
end
