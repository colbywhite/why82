require 'spec_helper'

RSpec.describe ParseHub::Parser do
  let(:dummy_class) { Class.new.include ParseHub::Parser }
  let(:parser) { dummy_class.new }

  before :each do
    allow(parser).to receive(:season_url) do |season|
      "spec/resources/#{season.short_name}_full.json"
    end
    allow(parser).to receive(:pull_season_json) do |season|
      url = parser.season_url season
      JSON.parse(File.read(url))['games']
    end
    @season = create(:season, short_name: '2015')
    Chronic.time_class = Time.find_zone('Eastern Time (US & Canada)')
  end

  describe '#pull_season_json' do
    it 'should return correct amount of games' do
      games_html = parser.pull_season_json @season
      expect(games_html.size).to eq(1230)
    end
  end

  describe '#build_time' do
    it 'should correctly handle EDT time zone' do
      game = { ParseHub::Parser::EASTERN_DATE => 'Wed, Apr 15, 2015',
               ParseHub::Parser::EASTERN_TIME => '7:00 pm' }
      time = parser.build_time game
      expect(time.to_json).to eq('"2015-04-15T19:00:00.000-04:00"')
    end

    it 'should correctly handle EST time zone' do
      game = { ParseHub::Parser::EASTERN_DATE => 'Fri, Nov 13, 2014',
               ParseHub::Parser::EASTERN_TIME => '10:30 pm' }
      time = parser.build_time game
      expect(time.to_json).to eq('"2014-11-13T22:30:00.000-05:00"')
    end
  end
end
