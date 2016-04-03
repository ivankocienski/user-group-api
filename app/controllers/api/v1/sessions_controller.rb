class Api::V1::SessionsController < ApplicationController

  def create
    auth_params = params[:auth] || {}

    render json: { token: 'abc123' } 
  end

end
