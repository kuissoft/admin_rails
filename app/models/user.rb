class User < ActiveRecord::Base
  has_one :sender_session, 
    class_name: "Session", 
    inverse_of: :sender, 
    foreign_key: "sender_id",
    dependent: :destroy
  has_one :recipient_session, 
    class_name: "Session", 
    inverse_of: :recipient, 
    foreign_key: "recipient_id",
    dependent: :destroy
  has_one :location,
    through: :sender_session
  
  # TODO: figure out production lengths and regexes
  validates :name, 
      length: { in: 3..70 },
      format: { with: /\A[A-Za-z ]+\z/ }
  validates :phone, 
    uniqueness: true, 
    length: { in: 4..20 },
    format: { with: /\A(\+)?[0-9 ]+\z/ }
  validates :email,
    uniqueness: true, 
    length: { in: 5..70 },
    format: { with: /\A.+(\@).+(\.).+\z/ }
  validates :password,  
    length: { in: 5..100 }
  validates :role, 
    :inclusion => 0..1
  
  scope :sorted, -> { order("role DESC, email ASC") }
end
