class Service < ActiveRecord::Base
  has_many :users_services
  has_many :users, through: :users_services


  def operators user_id = nil
    if users.any?
      return users.where.not(id: user_id)
    else
      return []
    end
  end
end
