class User < ActiveRecord::Base

  #
  # email stuff
  #

  EMAIL_NAME_REGEX  = '[\w\.%\+\-]+'.freeze
  DOMAIN_HEAD_REGEX = '(?:[A-Z0-9\-]+\.)+'.freeze
  DOMAIN_TLD_REGEX  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
  EMAIL_REGEX       = /\A#{EMAIL_NAME_REGEX}@#{DOMAIN_HEAD_REGEX}#{DOMAIN_TLD_REGEX}\z/i

  validates_presence_of :email, allow_nil: false
  validates_format_of :email, :with => EMAIL_REGEX
  validates :email, uniqueness: true

  #
  # username
  #

  validates :username, 
    length: { in: 3..100 }, 
    format: { with: /\A\w+\Z/, message: 'Contains bad characters' },
    presence: true

  #
  # password stuff
  #

  attr_accessor :password

  validates :password, length: { minimum: 5 }, allow_nil: false

  before_save :encode_password

  def test_password(string)
    test = Digest::SHA1.hexdigest(string + self.password_salt)

    test == self.password_encrypted
  end

  def encode_password
    return if @password.nil?

    self.password_salt      = Digest::SHA1.hexdigest(self.email + Date.today.to_s + "user-group-api")
    self.password_encrypted = Digest::SHA1.hexdigest(@password + self.password_salt)
    nil 
  end

  #
  # group stuff
  #

  has_many :user_groups
  has_many :groups, through: :user_groups

end
