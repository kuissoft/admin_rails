class Api::V1::FeedbacksController < Api::V1::ApplicationController
  respond_to :json

  def create
    @feedback = Feedback.new(@feedback_params)

    begin
        Emailer.feedback_email(@feedback).deliver
      rescue => e
        logger.error "Feedback::send_email => exception #{e.class.name} : #{e.message}"
      end
  
    if @feedback.save
      render json: {}, status: 200
    else
      render json: { error: { code: 101, message: @feedback.errors  } }, status: 400
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:feedback_type, :message, :email, :user_id)
  end
end
