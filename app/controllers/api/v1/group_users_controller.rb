class Api::V1::GroupUsersController < Api::V1::BaseController

  def create
    render json: { message: 'success' }
  end

end
