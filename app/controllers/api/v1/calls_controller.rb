class Api::V1::CallsController < Api::V1::ApplicationController
  def index
    render json: Rails.cache.get(params[:call_id])
  end
end
