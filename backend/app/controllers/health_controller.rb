# backend/app/controllers/health_controller.rb
class HealthController < ApplicationController
  def index
    render json: { status: "ok" }
  end
end
