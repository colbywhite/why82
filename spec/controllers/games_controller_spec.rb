require 'spec_helper'

RSpec.describe GamesController do
  before :each do
    @season = create(:season)
    @game_table = season_to_game_sym @season
  end

  describe 'GET #index' do
    def index(params = {})
      get :index, params
      assigns(:all)
    end

    describe 'paging' do
      before :each do
        # create two full pages worth of games and a third page with only one game
        @page_size = Sked::Application.config.games_per_page
        @games = (0..@page_size * 2).collect { create(@game_table) }
        expect(@games.size).to eq(@page_size * 2 + 1)
      end

      it 'returns only first page' do
        first_page = index
        expect(first_page[0]).to eq(@games[0])
        expect(first_page[@page_size - 1]).to eq(@games[@page_size - 1])
        expect(first_page.size).to eq(@page_size)
      end

      it 'returns only middle page' do
        second_page = index(page: '2')
        expect(second_page[0]).to eq(@games[@page_size])
        expect(second_page[4]).to eq(@games[@page_size * 2 - 1])
        expect(second_page.size).to eq(@page_size)
      end

      it 'returns partial last page' do
        third_page = index(page: '3')
        expect(third_page[0]).to eq(@games[@page_size * 2])
        expect(third_page.size).to eq(1)
      end
    end

    describe 'filtering' do
      before :each do
        # create eight teams
        @teams = (0..7).collect do |team_name|
          create(:team, name: team_name.to_s)
        end
        # create three games where team zero is the home team against teams 1-3
        @home_games = (1..3).collect do |i|
          create(@game_table, home: @teams[0], away: @teams[i])
        end
        # create three games where team four is the away team against teams 5-7
        @away_games = (5..7).collect do |i|
          create(@game_table, home: @teams[i], away: @teams[4])
        end
      end

      it 'filters on home games' do
        returned_home_games = index(home_teams: [@teams[0].id])
        expect(returned_home_games.size).to eq(3)
        (0..2).each { |i| expect(returned_home_games[i]).to eq(@home_games[i]) }
      end

      it 'filters on away games' do
        returned_away_games = index(away_teams: [@teams[4].id])
        expect(returned_away_games.size).to eq(3)
        (0..2).each { |i| expect(returned_away_games[i]).to eq(@away_games[i]) }
      end

      it 'filters on home & away games' do
        # should give me two games: 1@0 and 4@5
        returned_games = index(away_teams: [@teams[1].id, @teams[4].id],
                               home_teams: [@teams[0].id, @teams[5].id])
        expect(returned_games.size).to eq(2)
        expect(returned_games[0]).to eq(@home_games[0])
        expect(returned_games[1]).to eq(@away_games[0])
      end
    end
  end

  describe 'GET #graded' do
    before(:each) do
      #   create two 1s, two 2s, two 3s
      @first_tier_1 = create(:team, name: 'First Tier 1')
      give_team_record @game_table, @first_tier_1, 1, 1
      @second_tier_1 = create(:team, name: 'Second Tier 1')
      give_team_record @game_table, @second_tier_1, 10, TeamFilter::Record::TIER_ONE_CUTOFF

      @first_tier_2 = create(:team, name: 'First Tier 2')
      # halfway between tier two and tier one
      halfway_percentage = TeamFilter::Record::TIER_TWO_CUTOFF +
                           ((TeamFilter::Record::TIER_ONE_CUTOFF - TeamFilter::Record::TIER_TWO_CUTOFF) / 2)
      give_team_record @game_table, @first_tier_2, 10, halfway_percentage
      @second_tier_2 = create(:team, name: 'Second Tier 2')
      give_team_record @game_table, @second_tier_2, 10, TeamFilter::Record::TIER_TWO_CUTOFF

      @first_tier_3 = create(:team, name: 'First Tier 3')
      # halfway between tier one and 0
      halfway_percentage = TeamFilter::Record::TIER_ONE_CUTOFF / 2
      give_team_record @game_table, @first_tier_3, 10, halfway_percentage
      @second_tier_3 = create(:team, name: 'Second Tier 3')
      # a third of the way between 0 and
      third_percentage = TeamFilter::Record::TIER_ONE_CUTOFF / 3
      give_team_record @game_table, @second_tier_3, 10, third_percentage

      @game_date = Time.zone.local 2014, 12, 2, 19, 0, 0
      create_round_robin_games @game_table, @game_date,
                               @first_tier_1, @second_tier_1,
                               @first_tier_2, @second_tier_2,
                               @first_tier_3, @second_tier_3
    end

    it 'should grade games based on tiers' do
      get :graded, start_date: @game_date.iso8601, season: @season.short_name
      expect(response.status).to eq(200)
      body = JSON.parse response.body
      a_games = body['a']
      b_games = body['b']
      c_games = body['c']
      d_games = body['d']
      expect(a_games.size).to eq(1)
      expect(a_games.first['home']['id']).to eq(@first_tier_1.id)
      expect(a_games.first['away']['id']).to eq(@second_tier_1.id)

      expect(b_games.size).to eq(4)
      assert_all_games_contain_matching_team b_games, 'Tier 2'
      assert_all_games_contain_matching_team b_games, 'Tier 1'

      expect(c_games.size).to eq(1)
      expect(c_games.first['home']['id']).to eq(@first_tier_2.id)
      expect(c_games.first['away']['id']).to eq(@second_tier_2.id)

      expect(d_games.size).to eq(9)
      assert_all_games_contain_matching_team d_games, 'Tier 3'
    end
  end
end
