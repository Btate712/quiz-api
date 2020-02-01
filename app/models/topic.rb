class Topic < ApplicationRecord
  has_many :user_topics
  has_many :questions

  has_many :users, through: :user_topics

  validates_presence_of :name
  
  def self.for_user(user)
    if user.is_admin?
      Topic.all
    else
      Topic.all.filter do |topic|
        user.has_topic_rights?(topic, 10)
      end
    end
  end

  def destroy_dependents
    self.questions.each do |question|
      question.encounters.each { |encounter| encounter.destroy }
      question.comments.each { |comment| comment.destroy }
      question.destroy
    end
  end
end
