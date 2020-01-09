class ProjectTopic < ApplicationRecord
  belongs_to :project 
  belongs_to :topic

  validates_presence_of :topic_id, :project_id
end
