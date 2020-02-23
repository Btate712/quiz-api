class TopicsController < ApplicationController
  def index
    topics = Topic.for_user_as_hash(@current_user)
    render json: { status: "success", body: topics, message: "#{topics.length} topics found" }
  end

  def show
    topic = Topic.find(params[:id])
    if topic
      if @current_user.has_topic_rights?(topic, READ_LEVEL)
        render json: {
          status: "success",
          body: { topic_info: topic, questions: topic.questions },
          message: "Topic and #{topic.questions.length} questions received"
        }
      else
        render json: { status: "fail", message: "user does not have read access to this topic"}
      end
    else
      render json: { status: "fail", message: "topic not found" }
    end
  end

  def create
    topic = Topic.new({name: params[:name]})
    if topic.save
      user_topic = UserTopic.new(user_id: @current_user.id, topic_id: topic.id, access_level: 30)
      if user_topic.save
        project_topic = ProjectTopic.new(topic_id: topic.id, project_id: params[:project_id] )
        project_topic.save
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
    if topic && @current_user.has_topic_rights?(topic, WRITE_LEVEL)
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
    if topic && @current_user.has_topic_rights?(topic, WRITE_LEVEL)
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
