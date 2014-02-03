class Notification
  attr_accessor :type, :user

  def initialize notification_type, user_id, from_user_id
    # @id = SecureRandom.random_number(9999999)
    @type = notification_type
    # @user_id = user_id
    @user = {id: from_user_id, name: get_user_name(from_user_id)}
    # @created_at = Time.now
  end

  def get_user_name user_id
    user = User.where(id: user_id).first
    if user.name.blank?
      return user.phone
    else
      return user.name
    end
  end
end
