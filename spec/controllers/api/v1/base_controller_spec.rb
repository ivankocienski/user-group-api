require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do

  include CommonLettings

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

  context 'with_valid_auth_token' do

    controller do
      def index
        with_valid_auth_token do |t|
          @token = t
          render text: ''
        end
      end
    end
    
    it 'yields control with valid token' do
      payload = {
        api_token: user_auth_token.token,
        format: :json }

      get :index, payload

      expect(response).to be_success
      expect(assigns[:token]).to eq(user_auth_token)
    end

    it 'rejects missing token' do 
      payload = { format: :json }
      get :index, payload 
      expect(response.status).to eq(401)
      
      data = JSON.parse(response.body)
      expect(data['message']).to eq('Missing api_token')
    end

    it 'rejects token that does not exist' do
      payload = { 
        format: :json,
        api_token: '1234' }

      get :index, payload 
      expect(response.status).to eq(401)
      
      data = JSON.parse(response.body)
      expect(data['message']).to eq('Invalid api_token')
    end

    it 'rejects tokens that have expired' do
      token = UserAuthToken.generate(user)
      token.created_at = 10.hours.ago
      token.save 

      payload = { 
        format: :json,
        api_token: token.token }

      get :index, payload 
      expect(response.status).to eq(401)
      
      data = JSON.parse(response.body)
      expect(data['message']).to eq('api_token has expired, please log in again')
    end
  end

  context 'before filter' do 
    context 'user_must_be_present' do
      controller do
        before_filter :user_must_be_present

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
          payload = {
            api_token: user_auth_token.token,
            format: :json }

          get :index, payload
          expect(response).to be_success 
        end
      end

    end # user_must_be_logged_in

    context 'user_must_be_admin' do
      controller do
        before_filter :user_must_be_present
        before_filter :user_must_be_admin

        def index
          render text: ''
        end
      end

      it 'rejects non admin users' do
        payload = {
          api_token: user_auth_token.token,
          format: :json }

        get :index, payload
        expect(response.status).to eq(401) # forbidden

        data = JSON.parse(response.body)
        expect(data['message']).to eq('Only admins can perform that action')
      end

      it 'accepts admdin users' do
        payload = {
          api_token: admin_auth_token.token,
          format: :json }

        get :index, payload
        expect(response).to be_success 
      end
    end

  end # before filter

end
