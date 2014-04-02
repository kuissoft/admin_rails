class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact, :class_name => "User"

  validates_uniqueness_of :user_id, scope: :contact_id
  validates_presence_of :user_id, :contact_id
  validate :self_reference
  attr_accessor :id_user

  def self_reference
    if user_id == contact_id
      errors.add(:contact_id, ::I18n.t('errors.cant_add_yourself'))
    end
  end
end
