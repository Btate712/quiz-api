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

  def create
    question = Question.new(question_params)
    topic = Topic.find(question.topic_id)
    if @current_user.has_topic_edit_rights(topic)
      if question.save
        render json: { status: "success", body: question, message: "question ##{question.id} saved" }
      else
        render json: { status: "fail", message: "failed to create question" }
      end
    else
      render json: { status: "fail", message: "user does not have write access to this question/topic" }
    end
  end

  def update
    puts params
    question = Question.find(params[:id])
    topic = Topic.find(question.topic_id)
    new_topic = Topic.find(params[:topic_id])
    if @current_user.has_topic_edit_rights(topic) && @current_user.has_topic_edit_rights(new_topic)
      question.update(question_params)
      if question.save
        render json: { status: "success", body: question, message: "question ##{question.id} updated" }
      else
        render json: { status: "fail", message: "failed to update question" }
      end
    else
      render json: { status: "fail", message: "user does not have write access to this question/topic" }
    end
  end

  private

  def question_params
    params.permit(:topic_id, :stem, :choice_1, :choice_2, :choice_3, :choice_4, :correct_choice, :image_url)
  end
end
