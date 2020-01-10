class UserTopicsController < ApplicationController
  def index
    topics = Topic.all.filter{ |topic| @current_user.has_topic_rights?(topic, READ_LEVEL) }
    user_topics = []
    topics.each { |topic| user_topics.append(topic.user_topics) }
    render json: { status: "success", body: user_topics, message: "#{user_topics.length} topics found" }
  end

  def show
    user_topic = UserTopic.find(params[:id])
    if user_topic
      if @current_user.has_topic_rights?(user_topic.topic, READ_LEVEL)
        render json: {
          status: "success",
          body: user_topic,
          message: "user_topic ##{user_topic.id} received"
        }
      else
        render json: { status: "fail", message: "user does not have read access to this user_topic"}
      end
    else
      render json: { status: "fail", message: "user_topic not found" }
    end
  end

  def create
    user_topic = UserTopic.new(user_topic_params)
    if @current_user.has_topic_rights?(user_topic.topic, WRITE_LEVEL)
      if user_topic.save
        render json: { status: "success", body: topic, message: "new user_topic saved" }
      else
        render json: { status: "fail", message: "failed to create user_topic" }
      end
    else
      render json: { status: "fail", message: "user does not have access to assign users to this topic"}
    end
  end

  def update
    user_topic = UserTopic.find(params[:id])
    if user_topic
      if @current_user.has_topic_rights?(user_topic.topic, WRITE_LEVEL)
        user_topic.update(user_topic_params)
        if user_topic.save
          render json: { status: "success", body: topic, message: "user_topic updated" }
        else
          render json: { status: "fail", message: "updated user_topic failed to save" }
        end
      else
        render json: { status: "fail", message: "user does not have access to edit users for this topic" }
      end
    else
      render json: {status: "fail", message: "user_topic not found" }
    end
  end

  def destroy
    user_topic = UserTopic.find(params[:id])
    if user_topic && @current_user.has_topic_rights?(user_topic.topic, WRITE_LEVEL)
      user_topic.destroy
      render json: { status: "success", message: "user_topic removed" }
    else
      render json: { status: "fail", message: "cannot remove user_topic" }
    end
  end

  private

  def user_topic_params
    params.permit(:user_id, :topic_id, :access_level)
  end
end
