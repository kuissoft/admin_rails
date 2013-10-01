class User < ActiveRecord::Base
  DEFAULT_ROLE = 0

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

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

  has_many :connections, dependent: :destroy
  has_many :contacts, through: :connections

  # TODO: figure out production lengths and regexes
  validates :name,
      length: { in: 3..70 },
      format: { with: /\A[\p{Word} ]+\z/ }
  validates :phone,
    uniqueness: true,
    length: { in: 4..20 },
    format: { with: /\A(\+)?[0-9 ]+\z/ }
  validates :email,
    uniqueness: true,
    length: { in: 5..70 },
    format: { with: /\A.+(\@).+(\.).+\z/ }

  # validates :password, length: { in: 5..100 }
  validates :role, inclusion: 0..1

  scope :sorted, -> { order("role DESC, email ASC") }

  def admin?
    role == 1
  end

  def ensure_authentication_token
    assign_new_token if authentication_token.blank?
  end

  def assign_new_token
    self.last_token = self.authentication_token
    self.authentication_token = generate_authentication_token
    self.token_expires_at = 1.day.from_now
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.exists?(authentication_token: token)
    end
  end
end
