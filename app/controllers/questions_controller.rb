class QuestionsController < ApplicationController
  def index
    topics = Topic.for_user(@current_user)
    questions = []
    topics.each { |topic| questions.concat(topic.questions) }
    render json: { status: "success", body: questions, message: "#{questions.length} questions found" }
  end 
end
