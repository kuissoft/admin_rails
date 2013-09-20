class User < ActiveRecord::Base
  DEFAULT_ROLE = 0

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

  has_many :contacts, dependent: :destroy

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

  validates :password, length: { in: 5..100 }
  validates :role, inclusion: 0..1

  scope :sorted, -> { order("role DESC, email ASC") }

  def admin?
    role == 1
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.exists?(authentication_token: token)
    end
  end
end
