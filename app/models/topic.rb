class Topic < ApplicationRecord
  has_many :user_topics
  has_many :questions

  has_many :users, through: :user_topics

  def self.forUser(user)
    if user.is_admin?
      Topic.all
    else
      Topic.all.filter do |topic|
        topic.users.include? user
      end
    end 
  end
end
