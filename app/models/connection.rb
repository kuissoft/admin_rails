class Connection < ActiveRecord::Base
  validates_presence_of :user_id, :contact_id
  belongs_to :user
  belongs_to :contact, :class_name => "User"
end
