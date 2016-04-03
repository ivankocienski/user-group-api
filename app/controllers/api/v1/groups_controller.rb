class Api::V1::GroupsController < Api::V1::BaseController

  def create
    render json: { group: { id: 1234 }}
  end

end
