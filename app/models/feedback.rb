class Feedback < ActiveRecord::Base
  validates :feedback_type, :message, presence: true
  belongs_to :user
end
