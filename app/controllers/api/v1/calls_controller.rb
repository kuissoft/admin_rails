class Api::V1::CallsController < Api::V1::ApplicationController
	def index
		call = Rails.cache.read(params[:call_id])
		if call
			render json: call
		else
			render json: { error_info: { code: 101, message: t('errors.invalid_call_id') } }, status: 401
		end
	end
end


