class GamesController < ApplicationController
  include GamesHelper

  def index
    home_teams, away_teams = parse_teams_from_params
    @all = fetch_games home_teams, away_teams, params[:page]
    paging = build_paging_metadata @all
    respond_to do |format|
      # return 200 to prevent loading nonexistent html file
      format.html { render nothing: true }
      format.json do
        render json: { paging: paging, data: @all.as_json(game_json_options) }
      end
    end
  end

  def build_paging_metadata(collection)
    { current: collection.current_page, per_page: collection.per_page,
      total: collection.total_entries
    }
  end

  def parse_teams_from_params
    teams = to_i_set params[:teams]
    away_teams = to_i_set(params[:away_teams]) + teams
    home_teams = to_i_set(params[:home_teams]) + teams
    [home_teams, away_teams]
  end

  # converts array to a set with integers
  def to_i_set(arr)
    string_set = (arr || []).to_set
    to_i_collection string_set
  end

  # converts every ele in collection to integer
  def to_i_collection(collection)
    collection.collect(&:to_i)
  end

  def fetch_games(home_teams, away_teams, page_num)
    games = Game.eager_load_teams.paginate(page: page_num).order(:time)
    games = games.where { home_id >> home_teams } if home_teams.count > 0
    games = games.where { away_id >> away_teams } if away_teams.count > 0
    games
  end
end
