module Api
  module V1
    class Api::V1::ApplicationController < ActionController::Base
    	def index
		    call = Rails.cache.read(params[:call_id])
		    if call
		      render json: call
		    else
		      render json: { error_info: { code: 101, message: "Invalid call id" } }, status: 401
		    end
		  end
		end
	end
end
