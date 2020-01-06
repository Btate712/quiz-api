class Topic < ApplicationRecord
  has_many :user_topics
  has_many :questions

  has_many :users, through: :user_topics

  def self.for_user(user)
    if user.is_admin?
      Topic.all
    else
      Topic.all.filter do |topic|
        topic.users.include? user
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
