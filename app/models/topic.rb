class Topic < ApplicationRecord
  has_many :user_topics
  has_many :questions

  has_many :users, through: :user_topics

  validates_presence_of :name
  
  def self.for_user_as_hash(user)
    self.for_user(user).map { |topic| { topic: topic, questionCount: topic.questions.count, dateLastQuestionAdded: topic.date_last_question_added }}
  end

  def self.for_user(user)
    user.is_admin? ? Topic.all : Topic.all.filter { |topic| user.has_topic_rights?(topic, 10) }
  end

  def date_last_question_added
    last_question = self.questions.max_by do |question|
      question.created_at
    end
    last_question.created_at
  end

  def destroy_dependents
    self.questions.each do |question|
      question.encounters.each { |encounter| encounter.destroy }
      question.comments.each { |comment| comment.destroy }
      question.destroy
    end
  end
end
