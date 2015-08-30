class GamesController < ApplicationController
  include GamesHelper

  def get_set(arr)
    (arr || []).to_set
  end

  def index
    away_teams = get_set params[:away_teams]
    home_teams = get_set params[:home_teams]
    teams = get_set params[:teams]
    do_or = ActiveRecord::Type::Boolean.new.type_cast_from_user params[:or]
    away_teams += teams
    home_teams += teams
    away_teams = away_teams.collect { |t| t.to_i }
    home_teams = home_teams.collect { |t| t.to_i }
    puts "Away: #{away_teams.inspect}"
    puts "Home: #{home_teams.inspect}"
    @all = Game.eager_load_teams.order(:time)
    if (away_teams.count + home_teams.count) >0
      if do_or
        @all = @all.where{away_id >> away_teams.to_a | home_id >> home_teams.to_a}
      else
        if away_teams.empty?
          @all = @all.where{home_id >> home_teams.to_a}
        elsif home_teams.empty?
          @all = @all.where{away_id >> away_teams.to_a}
        else
          @all = @all.where{away_id >> away_teams.to_a & home_id >> home_teams.to_a}
        end
      end
    end
    respond_to do |format|
      puts format
      format.html # index.html.erb
      format.json { render json: @all.as_json(game_json_options) }
    end
  end
end
