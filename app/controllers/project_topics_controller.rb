class ProjectTopicsController < ApplicationController
  def create
    new_project_topic = ProjectTopic.new(project_id: params[:project_id], topic_id: params[:topic_id])
    if new_project_topic.save
      render json: { message: "Topic assigned to project" }
    else 
      render json: { message: "Failed to assign topic to project"}
    end
  end

end
