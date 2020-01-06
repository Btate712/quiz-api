class Question < ApplicationRecord
  belongs_to :topic

  has_many :encounters
  has_many :comments

  validates :stem, :choice_1, :choice_2, :choice_3, :choice_4, :correct_choice, :topic_id, presence: true
end
