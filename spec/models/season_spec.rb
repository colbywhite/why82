require 'spec_helper'

describe Season do
  before :each do
    # create 2 games, 2 teams for the season
    @season = create(:season, name: '2016')
    @spurs = create(:team, name: 'Spurs', season: @season)
    @rockets = create(:team, name: 'Rockets', season: @season)
    @gameone = create(:game, home: @spurs, away: @rockets, season: @season)
    @gametwo = create(:game, away: @spurs, home: @rockets, season: @season)
  end

  it 'should pick up teams relation' do
    expect(@season.teams.count).to eq(2)
  end

  it 'should pick up games relation' do
    expect(@season.games.count).to eq(2)
  end

  it 'should not allow null season for game' do
    null_create =
        -> { create(:game, away: @spurs, home: @rockets, season: nil) }
    expect(null_create).to(raise_error(ActiveRecord::StatementInvalid))
  end
end
