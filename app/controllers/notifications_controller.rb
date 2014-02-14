class NotificationsController < ApplicationController
  def index
      @feedbacks = Rpush::Apns::Feedback.all
      @notifications = Rpush::Apns::Notification.all
  end
end
