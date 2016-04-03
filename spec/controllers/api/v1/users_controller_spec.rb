require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'create' do
    context 'with valid input' do
      let(:payload) {{
        user: {
          username: 'username',
          password: 'password',
          email: 'user@example.com'
        },
        format: :json 
      }}

      it 'creates a user' do 
        expect {
          post :create, payload 
        }.to change(User, :count).by(1)
      end

      it 'responds appropriatly' do
        post :create, payload, format: :json
        expect(response).to be_success

        data = JSON.parse(response.body)
        expect(data['user']['id']).to be_a(Integer) 
      end
    end # with valid input

    context 'with invalid data' do
      let(:payload) {
        { format: :json }}

      it 'does not create user' do
        expect {
          post :create, payload
        }.not_to change(User, :count)
      end

      it 'gives meaningful feedback' do
        post :create, payload
        expect(response.status).to eq(422)

        data = JSON.parse(response.body)
        expect(data['message']).to eq('Failed to create user')
        expect(data).to have_key('errors')
      end
    end # with invalid data
  end # create 

  context 'show' do
    let(:user) { 
      User.create do |u|
        u.username = 'username'
        u.email    = 'user@example.com'
        u.password = 'password'
      end
    }
    let(:auth_token) {
      at = UserAuthToken.generate(user)
      at.save
      at
    }

    it 'returns user details' do
      payload = {
        api_token: auth_token.token,
        format: :json }

      get :show, payload
      expect(response).to be_success
      
      data = JSON.parse(response.body)
      expect(data['user']['username']).to eq(user.username)
      expect(data['user']['email']).to eq(user.email)

    end
  end
end
