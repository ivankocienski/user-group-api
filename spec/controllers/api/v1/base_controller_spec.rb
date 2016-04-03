require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do

  let(:user) { 
    User.create do |u|
      u.username = 'username'
      u.email    = 'user@example.com'
      u.password = 'password'
    end
  }

  context 'basic response' do
    controller do

      def index
        payload = { message: 'Hello, world' }
        respond_with payload
      end
    end

    it 'accepts and responds with JSON' do
      get :index, format: :json
      expect(response).to be_success
      header = response.header['Content-Type']
      expect(header).to include('application/json')
    end
  end # basic response

  context 'before filter' do 
    context 'find_user_from_token' do

      controller do
        before_filter :find_user_from_token

        def index
          render text: ''
        end
      end

      context 'without token' do
        it 'passes control' do
          get :index
          expect(response).to be_success
          expect(assigns[:user]).to be_nil
        end
      end

      context 'with token' do
        it 'finds user attached to token' do

          token = UserAuthToken.generate(user)
          token.save

          payload = {
            api_token: token.token,
            format: :json
          }

          get :index, payload
          expect(response).to be_success
          expect(assigns[:user]).to eq(user)
          
        end
        
      end # with token

    end # find_user_from_token

    context 'user_must_be_logged_in' do
      controller do
        before_filter :find_user_from_token
        before_filter :user_must_be_logged_in

        def index
          render text: ''
        end
      end

      context 'without token' do
        it 'rejects request' do
          get :index
          expect(response.status).to eq(401) # unauthorized
        end
      end

      context 'with token' do
        it 'passes control' do

          token = UserAuthToken.generate(user)
          token.save

          payload = {
            api_token: token.token,
            format: :json }

          get :index, payload
          expect(response).to be_success 
        end
      end

    end # user_must_be_logged_in

  end # before filter

end
