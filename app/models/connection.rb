class Connection < ActiveRecord::Base
  validates_presence_of :user_id, :contact_id
  belongs_to :user
  belongs_to :contact, :class_name => "User"

  validates_uniqueness_of :user_id, scope: :contact_id
  validate :self_reference

  def self_reference
    if user_id == contact_id
      errors.add(:contact_id, "can't add yourself as a contact")
    end
  end
end
