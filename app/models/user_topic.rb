class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates_presence_of :user_id, :topic_id, :access_level
  validates_uniqueness_of :topic_id, scope: [:user_id, :access_level], message: "User already has access."
end
