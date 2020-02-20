class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates_presence_of :user_id, :question_id, :comment_type
  validates_uniqueness_of :user_id, scope: [:question_id, :comment_type, :text], message: "comment already exists"
end
