require 'spec_helper'

RSpec.describe SeasonUpdates::Seeder do
  subject(:job) { SeasonUpdates::Seeder.new 'Test', '2015' }

  before :each do
    ActiveRecord::Base.logger.level = 1
    allow(job).to receive(:parse_doc) do |url|
      File.open(url) do |f|
        Nokogiri::HTML f
      end
    end
  end

  def get_season(short_name = '2015', name = 'Test')
    seasons = Season.where short_name: short_name, name: name
    expect(seasons.count).to eq(1)
    seasons.first
  end

  def get_league(abbr = SeasonUpdates::LEAGUE_ABBR, name = SeasonUpdates::LEAGUE_NAME)
    leagues = League.where abbr: abbr, name: name
    expect(leagues.count).to eq(1)
    leagues.first
  end

  describe '#seed' do
    before :each do
      allow(job).to(receive(:season_url)) { 'spec/resources/2015/20151030_games.html' }
      allow(job).to(receive(:team_url)) { 'spec/resources/2015/summary.html' }
    end

    context 'with empty db' do
      it 'should create league' do
        job.seed
        get_league
      end

      it 'should create season' do
        job.seed
        expect(get_season.league).to eq(get_league)
      end

      it 'should create 30 teams' do
        job.seed
        expect(get_season.teams.count).to eq(30)
      end

      it 'should create 26 games' do
        job.seed
        expect(get_season.games.count).to eq(26)
      end
    end
  end

  describe '#safe_seed' do
    before :each do
      allow(job).to receive(:seed).and_return(true)
    end

    context 'when BballRef is down' do
      before :each do
        allow(BballRef::Checker).to receive(:check).and_return(false)
      end

      it 'should not seed season' do
        job.safe_seed
        expect(job).not_to have_received(:seed)
      end
    end

    context 'when BballRef is up' do
      before :each do
        allow(BballRef::Checker).to receive(:check).and_return(true)
      end

      it 'should seed season' do
        job.safe_seed
        expect(job).to have_received(:seed)
      end
    end
  end
end
