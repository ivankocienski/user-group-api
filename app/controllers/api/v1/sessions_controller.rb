class Api::V1::SessionsController < ApplicationController

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

end
