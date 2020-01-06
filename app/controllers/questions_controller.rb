class QuestionsController < ApplicationController
  def index
    topics = Topic.for_user(@current_user)
    questions = []
    topics.each { |topic| questions.concat(topic.questions) }
    render json: { status: "success", body: questions, message: "#{questions.length} questions found" }
  end

  def show
    question = Question.find(params[:id])
    topic = question.topic
    if topic
      if @current_user.has_topic_read_rights(topic)
        render json: {
          status: "success",
          body: { question: question },
          message: "question ##{question.id} received"
        }
      else
        render json: { status: "fail", message: "user does not have read access to this question"}
      end
    else
      render json: { status: "fail", message: "question/topic not found" }
    end
  end
end
