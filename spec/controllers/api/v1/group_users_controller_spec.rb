require 'rails_helper'

RSpec.describe Api::V1::GroupUsersController, type: :controller do

  include CommonLettings

  context 'before filters' do
    context 'find_group' do

      controller do 
        before_filter :find_group

        def index
          render text: '' 
        end
      end

      it 'sets up @group' do
        payload = {
          group_id: group.id,
          format: :json,
          api_token: admin_auth_token.token }

        get :index, payload
        expect(response).to be_success
        expect(assigns[:group]).to eq(group)
      end

      it 'reports if group not found' do
        payload = {
          group_id: 1234,
          format: :json,
          api_token: admin_auth_token.token }

        get :index, payload
        expect(response.status).to eq(422) # unprocessible entity
        
        data = JSON.parse(response.body)
        expect(data['message']).to eq('A group with that ID could not be found')

      end
    end # find_group
  end # before filters

  context 'create' do
    context 'with valid input' do
      it 'creates link and responds sucessfully' do

        payload = {
          group_id: group.id,
          user: { id: admin.id },
          format: :json,
          api_token: admin_auth_token.token }

        expect {
          post :create, payload
        }.to change(UserGroup, :count).by(1)

        expect(response).to be_success
      end
    end

    context 'with invalid input' do
      context 'for user' do
        it 'gets rejected' do
          payload = {
            group_id: group.id,
            user: { id: 1234 },
            format: :json,
            api_token: admin_auth_token.token }

          post :create, payload 
          expect(response.status).to eq(422) # unprocessable

          data = JSON.parse(response.body)
          expect(data['message']).to eq('Could not find user') 
        end
      end # for user

      context 'for group' do
        it 'gets rejected' do

          admin.groups << group

          payload = {
            group_id: group.id,
            user: { id: admin.id },
            format: :json,
            api_token: admin_auth_token.token }

          post :create, payload
          expect(response.status).to eq(422) # unprocessable

          data = JSON.parse(response.body)
          expect(data['message']).to eq('Failed to link user to group') 

          errors = {
            "user" => ["already belongs to group"]}

          expect(data['errors']).to eq(errors)
        end

      end # for group 
    end # with invalid input
  end # create

end
