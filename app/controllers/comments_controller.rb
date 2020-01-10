class CommentsController < ApplicationController
  def index
    topics = Topic.for_user(@current_user)
    questions = []
    topics.each { |topic| questions.concat(topic.questions) }
    comments = []
    questions.each { |question| comments.concat(question.comments) }
    render json: { status: "success", body: comments, message: "#{comments.length} comments found" }
  end

  def show
    comment = Comment.find(params[:id])
    topic = comment.question.topic
    if topic
      if @current_user.has_topic_rights?(topic, READ_LEVEL)
        render json: {
          status: "success",
          body: comment,
          message: "comment ##{comment.id} received"
        }
      else
        render json: { status: "fail", message: "user does not have read access to this comment"}
      end
    else
      render json: { status: "fail", message: "comment not found" }
    end
  end

  def create
    params[:user_id] = @current_user.id
    params[:resolved] = false
    comment = Comment.new(comment_params)
    topic = Question.find(comment.question_id).topic
    if @current_user.has_topic_rights?(topic, WRITE_LEVEL)
      if comment.save
        render json: { status: "success", body: comment, message: "comment ##{comment.id} saved" }
      else
        render json: { status: "fail", message: "failed to create comment" }
      end
    else
      render json: { status: "fail", message: "user does not have write access to this question/topic" }
    end
  end

  def update
    comment = Comment.find(params[:id])
    topic = Question.find(comment.question_id).topic
    new_topic = params[:topic_id]
    if @current_user.has_topic_rights?(topic, WRITE_LEVEL) && @current_user.has_topic_rights?(new_topic, WRITE_LEVEL)
      comment.update(comment_params)
      if comment.save
        render json: { status: "success", body: comment, message: "comment ##{comment.id} updated" }
      else
        render json: { status: "fail", message: "failed to update comment" }
      end
    else
      render json: { status: "fail", message: "user does not have write access to this question/topic" }
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment
      topic = Question.find(comment.question_id).topic
      if topic && @current_user.has_topic_rights?(topic, WRITE_LEVEL)
        comment.destroy
        render json: { status: "success", message: "comment deleted" }
      else
        render json: { status: "fail", message: "cannot delete comment" }
      end
    end
  end

  private

  def comment_params
    params.permit(:question_id, :user_id, :text, :resolved)
  end
end
