require 'spec_helper'

RSpec.describe Utils::TeamRetriever do
  describe '#team' do
    let(:retriever) { Utils::TeamRetriever.new @season }

    before :each do
      @season = setup_2015_season
      @team = { name: 'Should Not Find', abbr: 'SNF' }
    end

    it 'should throw NoTeamFoundError' do
      expect do
        retriever.team @team
      end.to raise_error(Errors::NoTeamFoundError)
    end
  end
end
