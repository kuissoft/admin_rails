class Token < ActiveRecord::Base
  belongs_to :user
  belongs_to :session
  
  validates :token_id,
    presence: true # token ID has to be set
  validates :user,
    presence: true, # token has to belong to a user
    uniqueness: true # user can only have one active token
  validates :session, 
    presence: true # token has to belong to a session
    
  default_scope :order => "updated_at DESC"
end
