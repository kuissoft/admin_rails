class Feedback < ActiveRecord::Base
  validates :feedback_type, :message, presence: true
end
