class User < ActiveRecord::Base
  DEFAULT_ROLE = 'user'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  has_many :connections, dependent: :delete_all
  has_many :contact_connections, class_name: 'Connection', foreign_key: :contact_id, dependent: :delete_all
  has_many :contacts, through: :connections
  has_many :devices, dependent: :destroy

  # TODO: figure out production lengths and regexes
  #validates :name,
  #    length: { in: 3..70 },
  #    format: { with: /\A[\p{Word} ]+\z/ }
  validates :phone,
  uniqueness: true,
  length: { in: 4..20 },
  format: { with: /\A(\+)?[0-9 ]+\z/ }
  # validates :email,
  #   uniqueness: true,
  #   length: { in: 5..70 },
  #   format: { with: /\A.+(\@).+(\.).+\z/ }

  # validates :password, length: { in: 5..100 }
  validates :role, presence: true

  scope :sorted, -> { order("role DESC, email ASC") }

  def email_required?
    false
  end

  def admin?
    role == 'admin'
  end

  def expired_token?
    (token_updated_at + Settings.token_expiration_period) < Time.zone.now
  end

  def ensure_authentication_token
    assign_new_token if auth_token.blank?
  end

  def assign_new_token
    self.last_token = self.auth_token
    self.auth_token = generate_authentication_token
    self.token_updated_at = Time.zone.now
    save!
  end

  def follows_me? user_id
    followers.include?(user_id)
  end

  def following? user_id
    following.include?(user_id)
  end

  def followers
    Connection.where(contact_id: id).map(&:user_id)
  end

  def following
    connections.map(&:contact_id)
  end

  def following_each_other
    followers & following
  end

  def followers_uniq
    followers | following
  end

  def get_connection user_id
    connections.where(contact_id: user_id).first
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.exists?(auth_token: token)
    end
  end
end
