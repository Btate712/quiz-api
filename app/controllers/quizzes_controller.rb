class QuizzesController < ApplicationController
  def create
    topic_ids = params[:topicIds].split(",")
    number_of_questions = params[:numberOfQuestions].to_i
    
    questions = Quiz.makeQuiz(number_of_questions, topic_ids)
    quiz = questions.map do |question|
      {
        question: question,
        comments: question.comments
      }
    end
    render json: { quiz: quiz }
    
  end
end
