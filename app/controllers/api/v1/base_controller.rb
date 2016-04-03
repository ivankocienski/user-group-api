require 'json'

class Api::V1::BaseController < ActionController::Base

  respond_to :json


  private

#  def respond_json(obj, opts = {}) 
#    respond_to do |format|
#      format.json { render status: opts[:status], json: obj.to_json }
#    end
#  end

end

