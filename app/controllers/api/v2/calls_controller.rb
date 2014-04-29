class Api::V2::CallsController < Api::V2::ApplicationController
	def index
		call = Rails.cache.read(params[:call_id])
		if call
			render json: call
		else
			render json: { error_info: { code: 101, message: t('errors.invalid_call_id') } }, status: 401
		end
	end

  def dummy_call
    opentok = Opentok.new "38828842", "ec8af657e4471ea9b937ee7aca8f8669d9088ff1"

    render json: { session_id: opentok.session_id, caller_token: opentok.caller_token, assistant_token: opentok.assistant_token}, status: 200
  end
end


