class Api::V1::UsersController < Api::V1::BaseController

  def create
    user_params = params[:user] || {}

    user = User.new
    user.username = user_params[:username]
    user.password = user_params[:password]
    user.email    = user_params[:email]

    if user.save
      payload = { user: { id: user.id }}
      render json: payload 
    else
      render status: 422, json: { message: 'Failed to create user', errors: user.errors }
    end
  end

end
