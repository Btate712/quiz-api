class QuestionCommentsController < ApplicationController
  def index
    question = Question.find(params[:question_id])
    comments = question.comments 
    render json: { status: "success", body: comments, message: "#{comments.length} comments found" }
  end
end
