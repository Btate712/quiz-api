class QuestionCommentsController < ApplicationController
  def index
    question = Question.find(params[:question_id])
    body = question.comments.map do |comment| 
      user = User.find(comment.user_id)
      return { comment: comment, user_name: "Test User" }
    end
    render json: { status: "success", body: body, message: "#{comments.length} comments found" }
  end
end
