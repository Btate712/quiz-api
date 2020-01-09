class User < ApplicationRecord
  has_secure_password

  has_many :encounters
  has_many :comments
  has_many :user_topics
  has_many :user_projects

  has_many :topics, through: :user_topics
  has_many :projects, through: :user_projects
  
  validates_presence_of :name, :email, :password_digest
  validates :email, :name, uniqueness: true

  def has_topic_edit_rights(topic)
    has_rights = false
    if self.is_admin
      has_rights = true
    else
      if self.topics.include? topic
        user_topic = self.user_topics.find{ |u_topic| u_topic.topic_id == topic.id }
        if user_topic
          has_rights = true if user_topic.access_level >= 20
        end
      end
    end
  end

  def has_topic_read_rights(topic)
    has_rights = false
    if self.is_admin
      has_rights = true
    else
      if self.topics.include? topic
        user_topic = self.user_topics.find{ |u_topic| u_topic.topic_id == topic.id }
        has_rights = true if user_topic
      end
    end
  end
end
