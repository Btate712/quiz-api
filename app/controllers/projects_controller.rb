class ProjectsController < ApplicationController
  def index
    if @current_user.is_admin
      render json: {projects: Project.all}
    else
      render json: {projects: @current_user.projects}
    end
  end
end
