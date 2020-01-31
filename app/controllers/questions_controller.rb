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
      if @current_user.has_topic_rights?(topic, READ_LEVEL)
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
    if @current_user.has_topic_rights?(topic, WRITE_LEVEL)
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
    question = Question.find(params[:id])
    topic = Topic.find(question.topic_id)
    new_topic = Topic.find(params[:topic_id])
    if @current_user.has_topic_rights?(topic, WRITE_LEVEL) && @current_user.has_topic_rights?(new_topic, WRITE_LEVEL)
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

  def destroy
    question = Question.find(params[:id])
    if question
      topic = Topic.find(question.topic_id)
      if topic && @current_user.has_topic_rights?(topic, WRITE_LEVEL)
        question.destroy
        render json: { status: "success", message: "question deleted" }
      else
        render json: { status: "fail", message: "cannot delete question" }
      end
    end 
  end

  def batch_create
    questions = params[:questions]
    questions.each do |question|
      topic = question["topic"]
      question[:topic_id] = Topic.find_by(name: topic)
      if !question[:topic_id]
        question[:topic_id] = Topic.create(name: topic).id  
        ProjectTopic.create(project_id: params[:project_id], topic_id: question[:topic_id])
      end
      Question.create(
        topic_id: question[:topic_id],
        stem: question[:stem],
        choice_1: question[:choice1],
        choice_2: question[:choice2],
        choice_3: question[:choice3],
        choice_4: question[:choice4],
        correct_choice: question[:correct_choice]
      )
    end
  end 

  private

  def question_params
    params.permit(:topic_id, :stem, :choice_1, :choice_2, :choice_3, :choice_4, :correct_choice, :image_url)
  end
end
