class Connection < ActiveRecord::Base
  validates_presence_of :user_id
  belongs_to :user
  belongs_to :contact, :class_name => "User"

  
  validate :self_reference
  attr_accessor :id_user

  def self_reference
    if user_id == contact_id
      errors.add(:contact_id, "can't add yourself as a contact")
    end
  end
end
