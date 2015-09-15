class TeamsController < ApplicationController
  def index
    @all = Team.all.order(:abbr)

    stndrd_excepts = [:created_at, :updated_at]
    stndrd_excepts_opts = { except: stndrd_excepts }
    team_options = stndrd_excepts_opts.merge(methods: :logo)
    render json: @all.as_json(team_options)
  end
end
