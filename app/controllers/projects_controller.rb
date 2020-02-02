class ProjectsController < ApplicationController
  def index
    if @current_user.isAdmin
      render json: {projects: Project.all}
    else
      render json: {message: "Insufficient User Access Level"}
    end
  end
end
