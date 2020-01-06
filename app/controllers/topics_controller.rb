class TopicsController < ApplicationController
  def index
    topics = Topic.for_user(@current_user)
    render json: topics
  end

  def create
    topic = Topic.new(topic_params)
    if topic.save
      user_topic = UserTopic.new(user_id: @current_user.id, topic_id: topic.id, access_level: 30)
      if user_topic.save
        render json: { status: "success", body: topic, message: "new topic saved" }
      else
        topic.destroy
        render json: { status: "fail", message: "failed to create user_topic" }
      end
    else
      render json: { status: "fail", message: "topic failed to save" }
    end
  end

  def update
    topic = Topic.find(params[:id])
    if topic && @current_user.has_topic_edit_rights(topic)
      topic.update(topic_params)
      if topic.save
        render json: { status: "success", body: topic, message: "topic updated" }
      else
        render json: { status: "fail", message: "updated topic failed to save" }
      end 
    else
      render json: {status: "fail", message: "topic not found" }
    end
  end

  def destroy
    topic = Topic.find(params[:id])
    if topic && @current_user.has_topic_edit_rights(topic)
      topic.destroy_dependents
      topic.destroy
      render json: { status: "success", message: "topic deleted" }
    else
      render json: { status: "fail", message: "cannot delete topic" }
    end
  end

  private

  def topic_params
    params.permit(:name)
  end
end
