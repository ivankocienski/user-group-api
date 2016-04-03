require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do

  context 'create' do

    context 'with valid input' do
      let(:payload) {{
        group: { name: 'newgroup' },
        format: :json }}

      it 'creates group' do 
        expect {
          post :create, payload
        }.to change(Group, :count).by(1)
      end

      it 'returns ID' do
        post :create, payload
        expect(response).to be_success

        data = JSON.parse(response.body)
        group = Group.first
        expect(data['group']['id']).to eq(group.id)
        
      end
    end # with valid input

    context 'with invalid data' do
      it 'returns meaningful info to user' do
        payload = {
          format: :json }

        post :create, payload
        expect(response.status).to eq(422) # unprocessable

        data = JSON.parse(response.body)
        expect(data['message']).to eq('Failed to create group')

        expected_errors = {
          "name" => [
            "is too short (minimum is 3 characters)", 
            "Contains bad characters", 
            "can't be blank"]}

        expect(data['errors']).to eq(expected_errors)

      end
    end # with invalid data
  end

end
