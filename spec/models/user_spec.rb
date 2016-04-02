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
      User.new do |u|
        u.username = 'username'
        u.email    = 'user@example.com'
        u.password = 'password'
        u.save
      end

      u2 = User.new
      u2.email = 'user@example.com'

      expect( u2.valid? ).to be false
      expect( u2.errors ).to have_key( :email )
    end

  end

  context 'username' do
    it 'can be saved' do
      expect {
        User.create do |u|
          u.email    = 'user@example.com'
          u.username = 'user'
          u.password = 'password'
        end
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

  context 'password' do

    def make_user( args = {} )
      User.new do |u|
        u.email    = args[:email] || 'user@eample.com'
        u.username = args[:username] || 'auser'
        u.password = args[:password] || 'passwordpassword'
      end
    end

    context 'setting' do
      it 'must be present' do
        u = User.new
        u.email    = 'user@eample.com'
        u.username = 'auserdisplayname'

        expect(u.valid?).to be_falsey
        expect(u.errors).to have_key(:password)
      end

      it 'is salted and saved in DB' do
        user = make_user( password: '12345', password_confirmation: '12345' )

        user.save
        user.reload

        expect(user.password_encrypted.length > 0).to be(true)
        expect(user.password_encrypted).not_to eq('12345')
        expect(user.password_salt.length > 0).to be(true)
      end
    end

    context 'verifying' do
      let(:user) { make_user( password: '12345' ) }

      before :each do
        user.save
        user.reload
      end

      it 'correct positive' do 
        expect( user.test_password('12345') ).to be true
      end

      it 'correct negative' do 
        expect( user.test_password('54321') ).not_to be true
      end
    end
  end

end

