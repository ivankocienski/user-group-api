class Api::V1::BaseController < ActionController::Base 
  
  respond_to :json

  private

  # helper
  def with_valid_auth_token

    api_key = params[:api_token]
    if api_key.nil?
      return render status: 401, json: { message: 'Missing api_token' }
    end

    token = UserAuthToken.where(token: api_key).first
    if token.nil?
      return render status: 401, json: { message: 'Invalid api_token' }
    end

    if not token.renewable?  
      return render status: 401, json: { message: 'api_token has expired, please log in again' }
    end

    yield token
  end
  
  # filter
  def user_must_be_present

    with_valid_auth_token do |token|

      if token.expired?
        return render status: 401, json: { message: 'api_token has expired, please renew' }
      end

      @user = token.user
      if @user.nil?
        return render status: 422, json: { message: 'api_token user could not be found' }
      end
    end 
  end

  # filter
  def user_must_be_admin
    return if @user.admin

    render status: 401, json: { message: 'Only admins can perform that action' } 
  end

end

