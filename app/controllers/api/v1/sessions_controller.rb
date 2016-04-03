class Api::V1::SessionsController < Api::V1::BaseController

  before_filter :find_user_from_token, only: %i{ update }
  before_filter :user_must_be_logged_in, only: %i{ update }

  def create
    auth_params = params[:auth] || {}

    user = User.where(username: auth_params[:username]).first

    if user.nil? or not user.test_password(auth_params[:password])
      return render status: 401, json: { message: 'Authorization failed' }
    end

    token = UserAuthToken.generate(user)
    token.save

    render json: { token: token.token } 
  end

  def update
    if @auth.renewable?
      new_token = UserAuthToken.generate(@user) 
      render json: { api_token: new_token.token }

    else
      return render status: 422, json: { message: 'api_token is too old to renew, please log in again' }
    end 
  end

end
