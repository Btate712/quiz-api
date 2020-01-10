class EncountersController < ApplicationController
  def create
    failed = 0
    user_id = @current_user.id
    params[:questions].each do |question|
      e = Encounter.new(user_id: user_id, question_id: question[:id],
        selected_answer: question[:choice])
      if @current_user.has_topic_rights?(e.question.topic, READ_LEVEL)
        failed += 1 if !e.save
      else
        failed += 1
      end
    end
    render json: { message: "#{failed} encounters failed to save." }
  end

  def show
    # show method is actually being used as an index method filtered to
    # only provide information for the user whose user_id is supplied via the
    # ":id" portion of the URL.  The information returned via json is a summary
    # of quiz question performance for each topic.
    user_stats = Encounter.stats(@current_user)
    render json: { message: user_stats }
  end
end
