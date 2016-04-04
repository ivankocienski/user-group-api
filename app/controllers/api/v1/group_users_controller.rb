class Api::V1::GroupUsersController < Api::V1::BaseController

  before_filter :user_must_be_present
  before_filter :user_must_be_admin
  before_filter :find_group
  
  def create
    user_params = params[:user] || {}
    user = User.where(id: user_params[:id]).first

    if user.nil?
      return render status: 422, json: { message: 'Could not find user' }
    end

    begin
      user.groups << @group

    rescue ActiveRecord::RecordInvalid => e
      return render status: 422, json: { message: 'Failed to link user to group', errors: e.record.errors }
    end

    render json: { message: 'success' }
  end

  private
  
  def find_group
    @group = Group.where(id: params[:group_id]).first
    return if @group
    render status: 422, json: { message: 'A group with that ID could not be found' }
  end

end
