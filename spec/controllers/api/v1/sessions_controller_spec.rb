require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  include CommonLettings

  context 'create' do
    context 'with valid credentials' do
      it 'returns an auth token' do

        payload = {
          auth: {
            username: user.username,
            password: 'passwordpassword'
          },
          format: :json }

        post :create, payload 
        expect(response).to be_success
        
        data = JSON.parse(response.body)
        expect(data['token']).to be_a(String)
      end 
    end

    context 'with invalid credentials' do
      it 'responds appropriately' do

        payload = {
          format: :json }

        post :create, payload 
        expect(response.status).to eq(401)
        
        data = JSON.parse(response.body)
        expect(data['message']).to eq('Authorization failed')
      end
    end
  end

  context 'update' do # renew
    context 'with active token' do
      it 'issues new token' do
        payload = {
          api_token: user_auth_token.token,
          format: :json }

        put :update, payload
        expect(response).to be_success

        data = JSON.parse(response.body)
        expect(data['api_token']).to be_a(String)
      end
    end # with active token
  end # update

end
