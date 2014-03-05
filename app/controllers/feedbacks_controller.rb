class FeedbacksController < AuthenticatedController
  def index
    if params[:feedback_type].present?
      @feedbacks = Feedback.where(feedback_type: params[:feedback_type]).order('created_at desc')
    else
      @feedbacks = Feedback.order('created_at desc')
    end

    begin
      @web_feedbacks = ActiveSupport::JSON.decode(connect_api('feedbacks'))['feedbacks']
    rescue => e
      logger.error "Error: #{e.inspect}"
    end
  end


  def destroy
    if params[:model]
      api_destroy params
    else
      @feedback = Feedback.find(params[:id])
      @feedback.destroy
    end
    respond_to do |format|
      format.html { redirect_to feedbacks_url }
    end
  end
end
