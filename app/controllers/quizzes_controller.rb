class QuizzesController < ApplicationController
  def create
    topic_ids = params[:topicIds].split(",")
    number_of_questions = params[:numberOfQuestions].to_i
    
    questions = Quiz.makeQuiz(number_of_questions, topic_ids, @current_user)
    quiz = questions.map do |question|
      {
        question: question,
        comments: question.comments.map {|comment| { comment: comment, user_name: comment.user }}
      }
    end
    render json: { quiz: quiz }
    
  end
end
