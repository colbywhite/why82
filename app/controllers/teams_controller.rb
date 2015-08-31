class TeamsController < ApplicationController
  def index
    @all = Team.all.order(:abbr)
    render json: @all
  end
end
