require 'spec_helper'

RSpec.describe SeasonUpdates::TeamRetriever do
  describe '#team' do
    let(:retriever) { SeasonUpdates::TeamRetriever.new @season }

    before :each do
      @season = setup_2015_season
      @team = { name: 'Should Not Find', abbr: 'SNF' }
    end

    it 'should throw NoTeamFoundError' do
      expect do
        retriever.team @team
      end.to raise_error(SeasonUpdates::Errors::NoTeamFoundError)
    end
  end
end
