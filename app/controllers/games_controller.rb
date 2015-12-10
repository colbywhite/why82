class GamesController < ApplicationController
  include GamesHelper

  def graded
    validate_graded_params

    @season = params[:season]
    start_date = params[:start_date]
    end_date = params[:end_date]
    @tier_info = TeamFilter::Record.named_tiers @season, :team

    tier_ids = get_ids_from_tier_info @tier_info

    @a_games, @b_games, @c_games, @d_games = get_graded_games @season, start_date, end_date, tier_ids
    render_graded_games
  end

  def get_ids_from_tier_info(tiers)
    (1..3).collect do |tier|
      tiers[tier.to_s].collect(&:id)
    end
  end

  private

  def render_graded_games
    render json: { games: { a: @a_games.as_json,
                            b: @b_games.as_json,
                            c: @c_games.as_json,
                            d: @d_games.as_json },
                   teams: @tier_info,
                   params: params }
  end

  def get_graded_games(season, start_date, end_date, tiers)
    # A games are 1v1
    a_games = season.games_between_any_team start_date, end_date, tiers.first
    # B games are 1v2
    b_games = season.games_between_lists start_date, end_date, tiers.first, tiers.second
    # C games are 2v2
    c_games = season.games_between_any_team start_date, end_date, tiers.second
    # D games are the rest, which is any game with a 3
    d_games = season.games_including_any_team start_date, end_date, tiers.third

    [a_games, b_games, c_games, d_games]
  end

  def validate_graded_params
    param! :season, String,
           required: true, transform: ->(sn) { Season.find_by(short_name: sn) }
    param! :start_date, DateTime,
           required: true, transform: :beginning_of_day,
           default: -> { Time.zone.now }
    param! :end_date, DateTime,
           required: true, default: -> { params[:start_date].end_of_day }
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
    games = Nba2016Game.eager_load_teams.paginate(page: page_num).order(:time)
    games = games.where { home_id >> home_teams } if home_teams.count > 0
    games = games.where { away_id >> away_teams } if away_teams.count > 0
    games
  end
end
