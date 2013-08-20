class User < ActiveRecord::Base
  has_one :token, dependent: :destroy
end
