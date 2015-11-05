require 'spec_helper'

RSpec.describe TeamsController do
  describe 'GET index' do
    before :each do
      # create five teams
      @teams = (0..4).collect { create(:team) }
    end

    it 'returns all teams' do
      get :index
      expect(assigns(:all).size).to eq(5)
    end
  end
end
