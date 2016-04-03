require 'rails_helper'

RSpec.describe UserAuthToken, type: :model do

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

end
