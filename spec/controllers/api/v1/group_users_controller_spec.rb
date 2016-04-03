require 'rails_helper'

RSpec.describe Api::V1::GroupUsersController, type: :controller do

  context 'create' do
    it 'is successful' do
      payload = {
        group_id: 123,
        format: :json }

      post :create, payload
      expect(response).to be_success
    end
  end # create

end
