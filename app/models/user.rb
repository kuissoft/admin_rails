class User < ActiveRecord::Base
  DEFAULT_ROLE = 'user'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

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
  length: { in: 7..15 },
  format: { with: /\A(\+)?[0-9 ]+\z/ }
  # validates :email,
  #   uniqueness: true,
  #   length: { in: 5..70 },
  #   format: { with: /\A.+(\@).+(\.).+\z/ }
  validates :email, presence: true, if: -> {role == 'admin'}

  # validates :password, length: { in: 5..100 }
  validates :role, presence: true

  scope :sorted, -> { order("id DESC, role DESC, email ASC") }

  # User photo image #50x50 #100x100 #150x150 300x300x
  has_attached_file :photo, :styles => { :x300 => "300x300#", :x100 => "100x100#", :x150 => "150x150#", :x50 => "50x50#"  }, 
  :default_url => "/images/:style/missing.png", path: ":rails_root/public/images/photos/users/:id/:basename_:style",
   :url => "/images/photos/users/:id/:basename_:style"
# http://localhost:3000/users/3/photo/150/2014030912123454.jpg
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
  validates_attachment_size :photo, :in => 0..5.megabytes


  attr_accessor :remove
  before_post_process :rename_photo
  before_save :delete_photo, if: ->{ remove == '1' && !photo_updated_at_changed? }
  before_save :reset_password, if: -> { role == 'admin' && role_changed?}

  def delete_photo
    self.photo = nil
  end

  def rename_photo
    #photo_file_name - important is the first word - photo - depends on your column in DB table
    extension = File.extname(photo_file_name).downcase
    self.photo.instance_write :file_name, "#{Time.now.to_i.to_s}#{extension}"
  end


  def email_required?
    false
  end

  def admin?
    role == 'admin'
  end

  def role_changed?
    user = User.where(id: id).first
    user.role == 'user' if user
  end

  def reset_password!
    reset_password
    save
  end

  def reset_password
    new_password = SecureRandom.urlsafe_base64
    self.password = new_password
    Emailer.reset_password_email(self, new_password).deliver
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

  
end
