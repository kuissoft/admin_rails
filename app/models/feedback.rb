class Feedback < ActiveRecord::Base
  validates :feedback_type, :message, :email, presence: true
end
