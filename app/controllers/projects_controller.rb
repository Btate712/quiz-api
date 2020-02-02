class ProjectsController < ApplicationController
  def index
    render json: {projects: Project.all}
  end
end
