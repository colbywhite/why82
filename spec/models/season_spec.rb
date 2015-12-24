require 'spec_helper'

describe Season do
  before :each do
    # create 2 games, 2 teams for the season
    @season = create(:season, name: '2016')
    @game_table = season_to_game_sym @season
    @spurs = create_team_in_season @season, name: 'Spurs'
    @rockets = create_team_in_season @season, name: 'Rockets'
    @gameone = create(@game_table, home: @spurs, away: @rockets)
    @gametwo = create(@game_table, away: @spurs, home: @rockets)
  end

  it 'should pick up teams relation' do
    expect(@season.teams.count).to eq(2)
  end

  it 'should pick up games relation' do
    expect(@season.games.count).to eq(2)
  end

  it 'should not allow games in generic games table' do
    null_create =
        -> { create(:game, away: @spurs, home: @rockets) }
    expect(null_create).to(raise_error(ArgumentError))
  end
end
