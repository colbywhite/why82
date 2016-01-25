require 'spec_helper'

RSpec.describe GamesController do
  before :each do
    @season = setup_2015_season
    setup_oct_28_2015_games @season
    allow(controller).to receive(:overall_tiers) do
      tier_one = teams_with_abbr %w(NYK CLE UTA MIN)
      tier_two = teams_with_abbr %w(DAL OKC LAC WAS)
      tier_three = teams_without_abbr %w(NYK CLE UTA MIN DAL OKC LAC WAS)
      [tier_one, tier_two, tier_three]
    end
    @game_date = Time.zone.local 2014, 10, 30
  end

  describe 'GET #info' do
    context 'game grades' do
      def games
        get :info, start_date: @game_date.iso8601, season: @season.short_name, format: :json
        expect(response.status).to eq(200)
        JSON.parse(response.body)['games']
      end

      it 'should correctly grade \'A\' games' do
        a_games = games['a']
        expect(a_games.size).to eq(1)
        expect(a_games.first['home']['abbr']).to eq('CLE')
        expect(a_games.first['away']['abbr']).to eq('NYK')
      end

      it 'should correctly grade \'B\' games' do
        b_games = games['b']
        expect(b_games.size).to eq(1)
        expect(b_games.first['home']['abbr']).to eq('DAL')
        expect(b_games.first['away']['abbr']).to eq('UTA')
      end

      it 'should correctly grade \'C\' games' do
        c_games = games['c']
        expect(c_games.size).to eq(1)
        expect(c_games.first['home']['abbr']).to eq('LAC')
        expect(c_games.first['away']['abbr']).to eq('OKC')
      end

      it 'should correctly grade \'D\' games' do
        # the sort is to make the later assertion easier
        d_games = games['d'].sort_by { |g| g['home']['abbr'] }
        expect(d_games.size).to eq(2)
        expect(d_games.first['home']['abbr']).to eq('MIN')
        expect(d_games.first['away']['abbr']).to eq('DET')
        expect(d_games.second['home']['abbr']).to eq('ORL')
        expect(d_games.second['away']['abbr']).to eq('WAS')
      end
    end

    context 'team tiers' do
      it 'should correctly tier the teams'
    end
  end
end
