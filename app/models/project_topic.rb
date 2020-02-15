class ProjectTopic < ApplicationRecord
  belongs_to :project 
  belongs_to :topic

  validates_presence_of :topic_id, :project_id
  validates_uniqueness_of :project_id, scope: :topic_id, message: "Topic is already a member of this project."
end
