require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do

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
  end

end
