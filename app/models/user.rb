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

end
