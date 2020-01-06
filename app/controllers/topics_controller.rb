class TopicsController < ApplicationController
  def index
    topics = Topic.forUser(@current_user)
    render json: topics
  end
end
