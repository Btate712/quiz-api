class User < ApplicationRecord
  has_secure_password

  has_many :encounters
  has_many :comments
  has_many :user_topics

  has_many :topics, through: :user_topics
end
