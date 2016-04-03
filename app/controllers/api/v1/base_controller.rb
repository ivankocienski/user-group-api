class Api::V1::BaseController < ActionController::Base

  
  respond_to :json

  private

  def find_user_from_token
    token = params[:api_token]
    return if token.nil?

    auth = UserAuthToken.where(token: token).first
    return if auth.nil?

    # expired?
    @user = auth.user
  end
  
  def user_must_be_logged_in
    return if @user

    render status: 401, json: { message: 'Missing api_token' }
  end

end

