class Topic < ApplicationRecord
  has_many :user_topics
  has_many :questions

  has_many :users, through: :user_topics
end
