class ApplicationController < ActionController::API

  def missing_param(error)
    render json: {status: 400, error: error}, status: 400
  end

  def invalid_param(error, variants=nil)
    render json: {status: 404, error: error, variants: variants}, status: 404
  end

  def invalid_quantity(error, variants)
    render json: {status: 422, error: error, variants: variants}, status: 422
  end

  def action_failed
    render json: {status: 500, error: "application-crash"}, status: 500
  end
end
