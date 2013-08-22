class Session < ActiveRecord::Base
  has_many :tokens, dependent: :destroy
  
  validates :session_id,
    presence: true # session ID has to be set
    
  default_scope :order => "updated_at DESC"
end
