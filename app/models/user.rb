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
  
  validates_uniqueness_of :email
  validates_uniqueness_of :phone
  
  # TODO: figure out production lengths and regexes
  validates_length_of :name, :in => 3..70
  validates_length_of :phone, :in => 4..20
  validates_length_of :email, :in => 5..70
  validates_length_of :password, :in => 5..100

  validates_format_of :name, :with => /\A[A-Za-z ]+\z/
  validates_format_of :phone, :with => /\A(\+)?[0-9 ]+\z/
  validates_format_of :email, :with => /\A.+(\@).+(\.).+\z/
  
  validates :role, :inclusion => 0..1
  
  default_scope :order => "role DESC, email ASC"
end
