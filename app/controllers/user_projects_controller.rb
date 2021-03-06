class UserProjectsController < ApplicationController
  def create
    user_project = UserProject.new(user_project_params)
    if @current_user.is_admin
      if user_project.save
        render json: { status: "success", message: "new user_project saved" }
      else
        render json: { status: "fail", message: user_project.errors.messages.inspect }
      end
    else
      render json: { status: "fail", message: "user does not have access to assign users to projects"}
    end
  end

  private

  def user_project_params
    params.permit(:user_id, :project_id, :access_level)
  end
end
