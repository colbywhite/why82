require 'spec_helper'

RSpec.describe Game do
  describe '#by_team' do
    before :each do
      # create 15 games, 10 of which involve the Spurs
      @season = create(:season)
      @spurs = create(:team, name: 'Spurs')
      @games = create_games_for_team @spurs, @season
    end

    it 'returns both home and away' do
      spurs_games = @season.game_class.by_team @spurs.id
      expect(spurs_games.size).to eq(10)
      spurs_games = @spurs.games(@season)
      expect(spurs_games.size).to eq(10)
    end
  end
end
