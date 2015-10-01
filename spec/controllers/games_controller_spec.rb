require 'spec_helper'

RSpec.describe GamesController do
  describe 'GET index' do
    def index(page_num = '1')
      get :index, page: page_num
      assigns(:all)
    end

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
      second_page = index '2'
      expect(second_page[0]).to eq(@games[@page_size])
      expect(second_page[4]).to eq(@games[@page_size * 2 - 1])
      expect(second_page.size).to eq(@page_size)
    end

    it 'returns partial last page' do
      third_page = index '3'
      expect(third_page[0]).to eq(@games[@page_size * 2])
      expect(third_page.size).to eq(1)
    end
  end
end
