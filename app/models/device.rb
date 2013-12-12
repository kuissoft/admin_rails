class Device < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :token, :user_id
  validates_uniqueness_of :token
end
