class Project < ApplicationRecord
  has_many :user_projects
  has_many :users, through: :user_projects

  has_many :project_topics
  has_many :topics, through: :project_topics

  validates_presence_of :name
end
