class Api::V1::GroupsController < Api::V1::BaseController

  def create
    group_params = params[:group] || {}

    group = Group.new
    group.name = group_params[:name]

    if group.save 
      render json: { group: { id: group.id }}
    else
      render status: 422, json: { message: 'Failed to create group', errors: group.errors }
    end
  end

end
