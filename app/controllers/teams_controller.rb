class TeamsController < ApplicationController
  def tiers
    validate_tiers_params
    season = params[:season]
    @tiers = TeamFilter::Record.named_tiers season, :team
    @updated = season.last_updated_game.updated_at
    render json: { tiers: @tiers.as_json(season_for_record: season),
                   updated: @updated
           }
  end

  def validate_tiers_params
    param! :season, String,
           required: true, transform: ->(sn) { Season.find_by(short_name: sn) }
  end
end
