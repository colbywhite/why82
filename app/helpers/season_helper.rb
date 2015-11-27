module SeasonHelper
  def render_invalid_param(error)
    render json: { error: "Missing parameter: #{error.param}" },
           status: :bad_request
  end
end
