class NotificationsController < ApplicationController
  def index
      @feedbacks = Rapns::Apns::Feedback.all
      @notifications = Rapns::Apns::Notification.all
  end
end
