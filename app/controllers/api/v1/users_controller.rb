class Api::V1::UsersController < Api::V1::BaseController

  before_filter :find_user_from_token
  before_filter :user_must_be_logged_in, only: %i{ show }

  def show
    payload = {
      user: {
        username: @user.username,
        email: @user.email },
      groups: @user.groups.order(:name).map { |g| { id: g.id, name: g.name } }}

    render json: payload
  end

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
