
module CommonLettings

  def self.included( obj )
    obj.instance_eval do
      let(:user) { 
        new_user.tap do |u|
          u.save!
        end
      }

      let(:admin) { 
        new_user(admin: true).tap do |u|
          u.save!
        end
      }

      let(:user_auth_token) {
        UserAuthToken.generate(user).tap do |tk|
          tk.save!
        end
      }

      let(:admin_auth_token) {
        UserAuthToken.generate(admin).tap do |tk|
          tk.save!
        end
      }

      let(:group) { Group.create(name: 'group') }

    end
  end

  def new_user( args = {} )
    User.new do |u|
      u.email    = args[:email]    || 'user@eample.com'
      u.username = args[:username] || 'user'
      u.password = args[:password] || 'passwordpassword'
      u.admin    = args[:admin]
    end
  end

end

