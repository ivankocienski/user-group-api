class UserAuthToken < ActiveRecord::Base

  belongs_to :user

  EXPIRE_TIME = 1.hours
  RENEW_TIME  = 2.hours

  def expired?
    created_at < EXPIRE_TIME.ago
  end 

  def renewable?
    created_at > RENEW_TIME.ago
  end

  def self.generate(user)
    new do |at|
      at.token = Digest::SHA1.hexdigest("#{Random.rand(999999)}-#{Date.today}-user-group-api")
      at.user_id = user.id
    end
  end
  
end
