require 'spec_helper'

RSpec.describe Team do
  describe '#games' do
    before :each do
      # create 15 games, 10 of which involve the Spurs
      @spurs = create(:team, name: 'Spurs')
      @games = create_games_for_team @spurs
    end

    it 'returns all of a team\'s games' do
      spurs_games = @spurs.games
      expect(spurs_games.size).to eq(10)
    end
  end
end
