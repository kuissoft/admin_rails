class Contact < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, class_name: "User"
  validates_presence_of :user_id
  validates_presence_of :target_id
end
