require 'spec_helper'

RSpec.describe Team do
  describe '#games' do
    before :each do
      # create 15 games, 10 of which involve the Spurs
      @season = create(:season)
      @spurs = create(:team, name: 'Spurs')
      @games = create_games_for_team @spurs, @season
    end

    it 'returns all of a team\'s games' do
      spurs_games = @spurs.games @season
      expect(spurs_games.size).to eq(10)
    end
  end

  describe '#record' do
    before :each do
      @season = create(:season)
      @game_table = season_to_game_sym @season
      @spurs = create(:team, name: 'Spurs')
      @rockets = create(:team, name: 'Rockets')
    end

    it 'returns 0s when there are no played games' do
      assert_record_equals @spurs.record(@season), 0, 0, 0, 0.0
    end

    it 'returns correct record for single game' do
      create_game_with_score(@game_table, @spurs, 30, @rockets, 15)
      assert_record_equals @spurs.record(@season), 1, 0, 0, 1.0
      assert_record_equals @rockets.record(@season), 0, 1, 0, 0.0
    end

    it 'returns correct record for ties' do
      create_game_with_score(@game_table, @spurs, 30, @rockets, 30)
      assert_record_equals @spurs.record(@season), 0, 0, 1, 0.5
      assert_record_equals @rockets.record(@season), 0, 0, 1, 0.5
    end

    it 'returns correct record for both home/away games' do
      # split the rockets@spurs games
      create_game_with_score(@game_table, @spurs, 30, @rockets, 30)
      create_game_with_score(@game_table, @spurs, 30, @rockets, 20)
      create_game_with_score(@game_table, @spurs, 20, @rockets, 30)
      # 4 spurs road wins
      create_game_with_score(@game_table, @rockets, 20, @spurs, 30)
      create_game_with_score(@game_table, @rockets, 20, @spurs, 30)
      create_game_with_score(@game_table, @rockets, 20, @spurs, 30)
      create_game_with_score(@game_table, @rockets, 20, @spurs, 30)

      assert_record_equals @spurs.record(@season), 5, 1, 1, to_bigd('5.5', 7)
      assert_record_equals @rockets.record(@season), 1, 5, 1, to_bigd('1.5', 7)
    end
  end

  describe '#logo' do
    subject(:job) { UpdateSeason.new 'Reg', '2015' }

    before :each do
      # parse a month of the season so we can make assertions on the
      # teams created as a result
      allow(job).to receive(:season_url) do |season|
        "spec/resources/#{season.short_name}_one_incomplete_month.json"
      end
      allow(job).to receive(:pull_season_json) do |season|
        url = job.season_url season
        JSON.parse(File.read(url))['games']
      end
      @season = create(:season, short_name: '2015')
      Chronic.time_class = Time.find_zone('Eastern Time (US & Canada)')
      job.process_season 'Test', '2015'
    end

    it 'should be present for every team' do
      Team.all.map do |team|
        filename = team.logo.split('/')[-1]
        local_path = File.join 'app/assets/images/logos', filename
        expect(File).to exist(local_path)
      end
    end
  end
end
