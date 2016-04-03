require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do

  context 'create' do

    it 'is successful' do
      post :create
    end
  end

end
