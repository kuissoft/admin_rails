class FeedbacksController < AuthenticatedController
  def index
    if params[:feedback_type].present?
      @feedbacks = Feedback.where(feedback_type: params[:feedback_type]).order('created_at desc')
    else
      @feedbacks = Feedback.order('created_at desc')
    end
  end

  def show
  end

  def destroy
  end
end
