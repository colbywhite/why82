require 'spec_helper'

RSpec.describe BballRefParser do
  let(:dummy_class) { Class.new.include BballRefParser }
  let(:parser) { dummy_class.new }

  before :each do
    allow(parser).to receive(:season_url) do |season|
      "spec/resources/#{season.short_name}_full.html"
    end
    allow(parser).to receive(:parse_doc) do |url|
      File.open(url) do |f|
        Nokogiri::HTML f
      end
    end
    @season = create(:season, short_name: '2015')
    Chronic.time_class = Time.find_zone('Eastern Time (US & Canada)')
  end

  describe '#pull_season_html' do
    it 'should return all games' do
      games_html = parser.pull_season_html @season
      expect(games_html.size).to eq(1230)
    end
  end

  describe '#parse_game_html' do
    it 'should correctly parse game with EDT time zone' do
      expected = { home: { score: 92, name: 'Toronto Raptors', abbr: 'TOR' },
                   away: { score: 87, name: 'Charlotte Hornets', abbr: 'CHO' },
                   time: Chronic.parse('04/15/2015 7:00PM'),
                   extra_time: '' }
      assert_game_parsed '2015_single_edt.html', expected
    end

    it 'should correctly parse game with EST time zone' do
      expected = { home: { score: 90, name: 'Los Angeles Lakers', abbr: 'LAL' },
                   away: { score: 108, name: 'Houston Rockets', abbr: 'HOU' },
                   time: Chronic.parse('11/28/2014 10:30PM'),
                   extra_time: '' }
      assert_game_parsed '2015_single_est.html', expected
    end

    it 'should correctly parse game without scores' do
      expected = { home: { score: nil, name: 'Chicago Bulls', abbr: 'CHI' },
                   away: { score: nil, name: 'Charlotte Hornets', abbr: 'CHO' },
                   time: Chronic.parse('11/13/2015 8:00PM'),
                   extra_time: '' }
      assert_game_parsed '2016_single_scoreless.html', expected
    end

    def assert_game_parsed(game_file, expected)
      game = parser.parse_doc "spec/resources/#{game_file}"
      game_info = parser.parse_game_html game
      expect(game_info).to eq(expected)
    end
  end
end
