require 'spec_helper'

RSpec.describe GamesController do
  def index(params = {})
    get :index, params
    assigns(:all)
  end

  describe 'GET index paging' do
    before :each do
      # create two full pages worth of games and a third page with only one game
      @page_size = Sked::Application.config.games_per_page
      @games = (0..@page_size * 2).collect { create(:game) }
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

  describe 'GET index filtering' do
    before :each do
      # create eight teams
      @teams = (0..7).collect do |team_name|
        create(:team, name: team_name.to_s)
      end
      # create three games where team zero is the home team against teams 1-3
      @home_games = (1..3).collect do |i|
        create(:game, home: @teams[0], away: @teams[i])
      end
      # create three games where team four is the away team against teams 5-7
      @away_games = (5..7).collect do |i|
        create(:game, home: @teams[i], away: @teams[4])
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
