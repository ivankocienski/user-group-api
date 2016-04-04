require 'rails_helper'

RSpec.describe User, type: :model do

  include CommonLettings

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
        new_user.save
      }.to change( User, :count ).by(1)

      User.first.tap do |u|
        expect(u.username).to eq 'user'
      end
    end

    it 'must be valid' do
      u = new_user

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
    context 'setting' do
      it 'must be present' do
        u = new_user( password: '' )

        expect(u.valid?).to be_falsey
        expect(u.errors).to have_key(:password)
      end

      it 'is salted and saved in DB' do
        user = new_user( password: '12345' )

        user.save
        user.reload

        expect(user.password_encrypted.length > 0).to be(true)
        expect(user.password_encrypted).not_to eq('12345')
        expect(user.password_salt.length > 0).to be(true)
      end
    end

    context 'verifying' do
      it 'correct positive' do 
        expect(user.test_password('passwordpassword')).to be true
      end

      it 'correct negative' do 
        expect( user.test_password('54321') ).not_to be true
      end
    end
  end

  context 'groups' do 
    it 'can be assigned to users and retrieved' do 
      user.groups << group 
      expect(user.groups).to eq([group])
    end

    it 'must be unique' do
      expect {
        user.groups << group
        user.groups << group
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect(user.groups.count).to eq(1)
    end
  end

end

