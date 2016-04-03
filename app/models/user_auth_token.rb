class UserAuthToken < ActiveRecord::Base

  EXPIRE_TIME = 1.hours

  def expired?
    created_at <= EXPIRE_TIME.ago
  end 

end
