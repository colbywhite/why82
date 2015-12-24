require 'spec_helper'

RSpec.describe SeasonUpdates::Updater do
  subject(:job) { SeasonUpdates::Updater.new 'Test', '2015' }

  before :each do
    ActiveRecord::Base.logger.level = 1
    @nba2015 = setup_2015_season
    allow(job).to receive(:parse_doc) do |url|
      File.open(url) do |f|
        Nokogiri::HTML f
      end
    end
  end

  describe '#update_season' do
    context 'starting with some incomplete games' do
      before :each do
        setup_oct_29_2015_games @nba2015
        allow(job).to(receive(:season_url)) { 'spec/resources/2015/20151030_games.html' }
      end

      # Oct 30 games should be filled in; Oct. 31 games left incomplete
      it 'should update completed games' do
        job.update_season
        season = get_season '2015', 'Test'
        expect(season.games.count).to eq(26)
        expect(season.incomplete_games.count).to eq(6)
        expect(season.complete_games.count).to eq(20)
        expect(season.teams.count).to eq(30)
      end

      ## Not sure if this is valid anymore since it's not possible
      ## for #process_season to create teams anymore
      it 'should rollback if too many teams' do
        season = get_season '2015', 'Test'
        pre_process_team = create(:team)
        pre_process_team.seasons = [season]

        expect do
          job.update_season
        end.to raise_error(Exceptions::TooManyTeamsException)
      end

      ## Not sure if this is valid anymore since it's not possible
      ## for #process_season to create games anymore
      it 'should rollback if too many games' do
        season = get_season '2015', 'Test'
        game_sym = season_to_game_sym season
        create(game_sym)

        expect do
          job.update_season
        end.to raise_error(Exceptions::TooManyGamesException)
      end
    end

    context 'starting with all incomplete games' do
      before :each do
        setup_oct_28_2015_games @nba2015
        allow(job).to(receive(:season_url)) { 'spec/resources/2015/20151030_games.html' }
      end

      it 'should update completed games' do
        job.update_season
        season = get_season '2015', 'Test'
        expect(season.games.count).to eq(26)
        expect(season.incomplete_games.count).to eq(6)
        expect(season.complete_games.count).to eq(20)
        expect(season.teams.count).to eq(30)
      end
    end

    context 'when a gametime changes' do
      before :each do
        setup_oct_29_2015_games @nba2015
        # This file changes the gametime for the CLE@CHI game
        allow(job).to(receive(:season_url)) { 'spec/resources/2015/20151030_games_new_time.html' }
        @chi = Team.find_by abbr: 'CHI', name: 'Chicago Bulls'
        @cle = Team.find_by abbr: 'CLE', name: 'Cleveland Cavaliers'
      end

      it 'should update to new gametime' do
        season = get_season '2015', 'Test'
        gametime_before = @chi.games(season).joins(:away).find_by(away: @cle).time
        job.update_season
        gametime_after = @chi.games(season).joins(:away).find_by(away: @cle).time
        expect(gametime_before).not_to eq(gametime_after)
        expect(Time.utc(2014, 11, 1, 1)).to eq(gametime_after)
      end
    end

    def get_season(short_name, name)
      seasons = Season.where short_name: short_name, name: name
      expect(seasons.count).to eq(1)
      seasons.first
    end
  end

  describe '#get_season' do
    context 'when no valid season exists' do
      it 'should throw NoSeasonFoundError' do
        expect do
          job.get_season 'Not Found', 'NF'
        end.to raise_error(Errors::NoSeasonFoundError)
      end
    end
  end

  describe '#perform' do
    before :each do
      allow(job).to receive(:update_season).and_return(true)
    end

    context 'when BballRef is down' do
      before :each do
        allow(BballRef::Checker).to receive(:check).and_return(false)
      end

      it 'should not update season' do
        job.perform
        expect(job).not_to have_received(:update_season)
      end
    end

    context 'when BballRef is up' do
      before :each do
        allow(BballRef::Checker).to receive(:check).and_return(true)
      end

      it 'should update season' do
        job.perform
        expect(job).to have_received(:update_season)
      end
    end
  end
end
