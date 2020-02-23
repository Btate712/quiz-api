class Quiz < ApplicationRecord
  def self.makeQuiz(number_of_questions, topic_ids, user)
    questions_per_topic = (number_of_questions.to_i / topic_ids.count)
    quiz_questions = []
    spare_questions = []

    # take an equal number of questions from each topic and store those
    # questions in the quiz_questions array
    topic_ids.shuffle.each do |topic_id|
      topic_questions = Topic.find(topic_id).questions.shuffle
      if number_of_questions < topic_ids.count
        if quiz_questions.count < number_of_questions.to_i
          topic_questions.last.dont_ask?(user) ? topic_questions.pop : quiz_questions.push(topic_questions.pop) 
        end
      else
        questions_per_topic.times do
          if(!topic_questions.empty?)
            topic_questions.last.dont_ask?(user) ? topic_questions.pop : quiz_questions.push(topic_questions.pop)
          end
        end
        #grab extra questions for each topic to fill in the remaining questions
        until topic_questions.empty? 
          topic_questions.last.dont_ask?(user) ? topic_questions.pop : spare_questions.push(topic_questions.pop)
        end
      end
    end

    # grab questions from spare_questions array until enough are selected
    spare_questions.shuffle
    until quiz_questions.length == number_of_questions || spare_questions.empty?
      quiz_questions.push(spare_questions.pop)
    end

    quiz_questions.shuffle
  end
end
