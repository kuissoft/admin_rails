class UsersService < ActiveRecord::Base
  belongs_to :user
  belongs_to :service

  validates_presence_of :service_id, :user_id
end
