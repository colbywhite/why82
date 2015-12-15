class SeasonController < ApplicationController
  include SeasonHelper
  protect_from_forgery with: :null_session
  rescue_from RailsParam::Param::InvalidParameterError,
              with: :render_invalid_param

  def update
    param! :name, String, required: true
    param! :short_name, String, required: true

    job = SeasonUpdates::Updater.new params[:name], params[:short_name]
    Delayed::Job.enqueue job
    head :no_content
  end
end
