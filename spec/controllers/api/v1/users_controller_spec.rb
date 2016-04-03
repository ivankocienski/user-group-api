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
    end 

    it 'rejects user with invalid input'
  end 
end
