class Api::V1::FeedbacksController < Api::V1::ApplicationController
  respond_to :json

  def create
    feedback = Feedback.new(feedback_params)
  
    if feedback.save
      render json: {success: true}, status: 200
    else
      render json: { error: feedback.errors }, status: 400
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:feedback_type, :message, :email, :user_id)
  end
end