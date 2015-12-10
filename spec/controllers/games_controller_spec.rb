require 'spec_helper'

RSpec.describe GamesController do
  before :each do
    @season = create(:season)
    @game_table = season_to_game_sym @season
  end

  describe 'GET #info' do
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

    it 'should grade games based on team tiers' do
      get :info, start_date: @game_date.iso8601, season: @season.short_name, format: :json
      expect(response.status).to eq(200)
      games = JSON.parse(response.body)['games']
      a_games = games['a']
      b_games = games['b']
      c_games = games['c']
      d_games = games['d']
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

    it 'should return teams based on tiers'
  end
end
