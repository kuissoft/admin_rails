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
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to feedbacks_url }
    end
  end
end
