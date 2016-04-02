require 'rails_helper'

RSpec.describe User, type: :model do
  context 'email' do
    it 'must be set' do

      u = User.new
      u.save

      expect( u.valid? ).to be false
      expect( u.errors ).to have_key( :email )

    end

    it 'must be valid' do
      u = User.new
      u.email = 'bademail' # not really

      expect( u.valid? ).to be false
      expect( u.errors ).to have_key( :email )
    end

    it 'must be unique' do
      u1 = User.new
      u1.email = 'user@example.com'
      u1.save

      u2 = User.new
      u2.email = 'user@example.com'

      expect( u2.valid? ).to be false
      expect( u2.errors ).to have_key( :email )
    end

  end

end

