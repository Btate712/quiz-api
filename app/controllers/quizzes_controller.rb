class QuizzesController < ApplicationController
  def create
    topic_ids = params[:topicIds].split(",")
    number_of_questions = params[:numberOfQuestions].to_i
    
    render json: { quiz: Quiz.makeQuiz(number_of_questions, topic_ids) }
    
  end
end
