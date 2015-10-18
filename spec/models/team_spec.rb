require 'spec_helper'

RSpec.describe Team do
  describe '#games' do
    before :each do
      # create 15 games, 10 of which involve the Spurs
      @spurs = create(:team, name: 'Spurs')
      # create five random games that do not contain the Spurs
      @games = (0..4).collect { create(:game) }
      # create five home games for the Spurs, then five away
      @games += (0..4).collect { create(:game, home: @spurs) }
      @games += (0..4).collect { create(:game, away: @spurs) }
    end

    it 'returns all of a team\'s games' do
      spurs_games = @spurs.games
      expect(spurs_games.size).to eq(10)
    end
  end
end
