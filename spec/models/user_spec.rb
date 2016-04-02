require 'rails_helper'

RSpec.describe User, type: :model do
  context 'email' do
    it 'must be set' do
      u = User.new

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
      u1.username = 'username'
      u1.email    = 'user@example.com'
      u1.save

      u2 = User.new
      u2.email = 'user@example.com'

      expect( u2.valid? ).to be false
      expect( u2.errors ).to have_key( :email )
    end

  end

  context 'username' do
    it 'can be saved' do
      expect {
        User.create( 
                    email: 'user@example.com',
                    username: 'user')
      }.to change( User, :count ).by(1)

      User.first.tap do |u|
        expect(u.username).to eq 'user'
      end
    end

    it 'must be valid' do
      u = User.new( email: 'user@example.com' )

      # ni;
      u.username = ''
      expect(u.valid?).to be_falsey

      err = u.errors[:username]
      expect(err).to include("can't be blank")
      
      # wrong length
      u.username = 'x'
      expect(u.valid?).to be_falsey

      err = u.errors[:username]
      expect(err).to include("is too short (minimum is 3 characters)")
      
      u.username = 'x' * 1000
      expect(u.valid?).to be_falsey

      err = u.errors[:username]
      expect(err).to include("is too long (maximum is 100 characters)")

      # bad format
      u.username = '-? ^#@&^('
      expect(u.valid?).to be_falsey

      err = u.errors[:username]
      expect(err).to include("Contains bad characters")
    end
  end

end

