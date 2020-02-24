class CommentsController < ApplicationController
  def index
    question = Question.find(params[:question_id])
    if question 
      body = question.comments.map do |comment| 
        user = User.find(comment.user_id)
        return { comment: comment, user_name: user ? user.name : "Not Found" }
      end 
    end
    puts "Body: #{body}"
    render json: { status: "success", body: body, message: "#{comments.length} comments found" }
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
    comment = Comment.new(
      question_id: params[:question_id].to_i,
      user_id: @current_user.id,
      text: params[:text],
      resolved: false,
      comment_type: params[:comment_type]
    )
    topic = Question.find(comment.question_id).topic
    if @current_user.has_topic_rights?(topic, READ_LEVEL)
      if comment.save
        render json: { status: "success", body: { comment: comment, user_name: comment.user }, message: "comment ##{comment.id} saved" }
      else
        render json: { status: "fail", message: comment.errors.messages[:user_id] }
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
      if topic && (@current_user.has_topic_rights?(topic, WRITE_LEVEL) || comment.user == @current_user)
        comment.destroy
        render json: { status: "success", message: "comment deleted" }
      else
        render json: { status: "fail", message: "cannot delete comment" }
      end
    end
  end

  private

  def comment_params
    params.permit(:question_id, :user_id, :text, :resolved, :type)
  end
end
