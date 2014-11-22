
class User < ActiveRecord::Base
  DEFAULT_ROLE = 'user'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable #, :validatable

  has_many :connections, dependent: :delete_all
  has_many :contact_connections, class_name: 'Connection', foreign_key: :contact_id, dependent: :delete_all
  has_many :contacts, through: :connections
  has_many :devices, dependent: :destroy

  has_many :users_services
  has_many :services, through: :users_services

  accepts_nested_attributes_for :users_services


  # TODO: figure out production lengths and regexes
  #validates :name,
  #    length: { in: 3..70 },
  #    format: { with: /\A[\p{Word} ]+\z/ }
  validates_uniqueness_of :phone, unless: -> {role == 'operator'}
  validates_length_of :phone, in: 7..15, unless: -> {role == 'operator'}
  validates_format_of :phone, with: /\A(\+)?[0-9 ]+\z/, unless: -> {role == 'operator'}
  validates_presence_of :phone
  # validates :email,
  #   uniqueness: true,
  #   length: { in: 5..70 },
  #   format: { with: /\A.+(\@).+(\.).+\z/ }
  validates :email, presence: true, if: -> {role == 'admin' or role == 'operator'}

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
  before_validation :set_password, on: :create

  def set_password
    self.password = SecureRandom.urlsafe_base64
  end

  def delete_photo
    self.photo = nil
  end

  def rename_photo
    #photo_file_name - important is the first word - photo - depends on your column in DB table
    extension = File.extname(photo_file_name).downcase
    self.photo.instance_write :file_name, "#{Time.now.to_i.to_s}#{extension}"
  end

  # Check if any of user devices are online and if yes return true
  def is_online?
    devices.select{|d| d.online == true }.any?
  end

  def get_language
    devices.first.language
  end


  def strongest_connection
    return "offline" if !is_online?
    networks = {'Unknown' => 0, 'GPRS' => 1, 'Edge' => 2, '3G' => 3, '4G' => 4, 'LTE' => 5, 'Wi-Fi' => 6}
    max = 0
      devices.each do |d|
        if d.connection_type.present?
          max = networks[d.connection_type] if d.online and !networks[d.connection_type].nil? and networks[d.connection_type] > max
          return d.connection_type if max == 6
        end
      end
    networks.key(max)
  end

  def email_required?
    false
  end

  def admin?
    role == 'admin'
  end

  def operator?
    role == 'operator'
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
    begin
      Emailer.reset_password_email(self, new_password).deliver
    rescue => e
      Rails.logger.error "#E-mail not send: {r.inspect}"
    end
  end

  def reset_sms!
    self.sms_count = 0
    self.reset_count = reset_count + 1
    save
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

  def get_name_or_phone
    if name.blank?
      return phone
    else
      return name
    end
  end

  def get_auth_tokens
    devices.map(&:auth_token).join(",")
  end

  
end
