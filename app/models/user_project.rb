class UserProject < ApplicationRecord
  belongs_to :user 
  belongs_to :project

  validates_presence_of :user_id, :project_id, :access_level
  validates_uniqueness_of :project_id, scope: [:user_id, :access_level], message: "User already has access."
end

