class Api::V1::CallsController < Api::V1::ApplicationController
  def index
    render json: Rails.cache.read(params[:call_id])
  end
end
