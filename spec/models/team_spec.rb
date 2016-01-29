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
    before :each do
      # add the 30 relevant teams so we can assert we have logos for every one
      setup_2015_season
    end

    it 'should be present for every team' do
      Team.all.map do |team|
        filename = team.logo.split('/')[-1]
        local_path = File.join 'app/assets/images/logos', filename
        expect(File).to exist(local_path)
      end
    end
  end

  describe '#last_ten_record' do
    before :each do
      @season = setup_2015_season
      setup_oct_28_2015_games @season
    end

    context 'no games played' do
      it 'should return 0-0 records for all teams' do
        @season.teams.each do |team|
          expect(team.last_ten_record(@season)).to eq_record(0, 0, 0)
        end
      end
    end

    context 'less than 10 games played' do
      before :each do
        # grabbing a CLE game since they don't play LAL
        cle = @season.teams.find_by abbr: 'CLE'
        first_game = cle.games(@season).first
        @winner = first_game.home
        @loser = first_game.away
        first_game.home_score = 100
        first_game.away_score = 90
        first_game.save

        # using the LAL since they have three games in the data set, which is the most
        @lal = @season.teams.find_by abbr: 'LAL'
        games = @lal.games @season
        # LAL has two home games, so this will give them two wins and a loss
        games.each do |game|
          game.home_score = 100
          game.away_score = 90
          game.save
        end
      end

      it 'should calculate record properly for undefeated' do
        expect(@winner.last_ten_record(@season)).to eq_record(1, 0, 0)
      end

      it 'should calculate record properly for winless' do
        expect(@loser.last_ten_record(@season)).to eq_record(0, 1, 0)
      end

      it 'should calculate record properly for a team with both wins and losses' do
        expect(@lal.last_ten_record(@season)).to eq_record(2, 1, 0)
      end
    end

    context 'more than 10 games played' do
      before :each do
        game_sym = season_to_game_sym @season
        @team_a = @season.teams.first
        @team_b = @season.teams.second

        # create 5 games where team_b wins
        (0..0).to_a.product((1..5).to_a).each do |scores|
          create_game_with_score game_sym, @team_a, scores.first, @team_b, scores.second
        end
        # create 7 games where team_a wins
        (0..0).to_a.product((1..7).to_a).each do |scores|
          create_game_with_score game_sym, @team_b, scores.first, @team_a, scores.second
        end
        # create 2 more where team_b wins
        (0..0).to_a.product((1..2).to_a).each do |scores|
          create_game_with_score game_sym, @team_a, scores.first, @team_b, scores.second
        end
        # so team_a should be 7-7, and team_b should 7-7 overall
        # but in the last ten, team_a should be 7-3 and team_b should be 3-7
      end

      it 'should calculate record properly for a winning team' do
        expect(@team_a.last_ten_record(@season)).to eq_record(7, 3, 0)
      end

      it 'should calculate record properly for a losing team' do
        expect(@team_b.last_ten_record(@season)).to eq_record(3, 7, 0)
      end
    end
  end
end
