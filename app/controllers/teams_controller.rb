class TeamsController < ApplicationController
  def tiers
    validate_tiers_params
    season = params[:season]
    @tiers = TeamFilter::Record.named_tiers season, :team
    @updated = season.last_updated_game.updated_at
    render json: { tiers: @tiers.as_json(team_options.merge(season: season)),
                   updated: @updated
           }
  end

  def validate_tiers_params
    param! :season, String,
           required: true, transform: ->(sn) { Season.find_by(short_name: sn) }
  end

  def team_options
    stndrd_excepts = [:created_at, :updated_at]
    stndrd_excepts_opts = { except: stndrd_excepts }
    stndrd_excepts_opts.merge(methods: :logo)
  end
end
