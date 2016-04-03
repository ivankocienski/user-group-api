require 'rails_helper'

RSpec.describe UserAuthToken, type: :model do

  let(:user) { 
    User.create do |u|
      u.username = 'username'
      u.email    = 'user@example.com'
      u.password = 'password'
    end
  }

  context '#expired?' do
    it 'is false if record is new' do
      at = UserAuthToken.create
      expect(at.expired?).to be_falsey
    end

    it 'is true if record is too old' do
      at = UserAuthToken.create(created_at: (UserAuthToken::EXPIRE_TIME + 10).hours.ago)
      expect(at.expired?).to be_truthy
    end
  end

  context '#renewable?' do
    it 'is true if record is new' do
      at = UserAuthToken.create
      expect(at.renewable?).to be_truthy
    end

    it 'is false if record is too old' do
      at = UserAuthToken.create(created_at: (UserAuthToken::RENEW_TIME + 10).hours.ago)
      expect(at.renewable?).to be_falsey
    end
  end

  context '::generate' do
    
    it 'generates a token' do
      at = UserAuthToken.generate(user)
      expect(at.token).not_to be_empty
    end

    it 'assigns user ID' do
      at = UserAuthToken.generate(user)
      expect(at.user_id).to eq(user.id) 
    end

    it 'token is unique' do
      at1 = UserAuthToken.generate(user)
      at2 = UserAuthToken.generate(user)

      expect(at1.token).not_to eq(at2.token)
    end
  end

end
