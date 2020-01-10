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

  def has_topic_rights?(topic, required_access_level)
    has_rights = false
    if self.is_admin
      has_rights = true
    end 
    if (!has_rights)
      if self.topics.include? topic
        user_topic = self.user_topics.find{ |u_topic| u_topic.topic_id == topic.id }
        if user_topic
          has_rights = true if user_topic.access_level >= required_access_level
        end
      end
    end
    if (!has_rights)
      self.projects.each do |project|
        if project.topics.include? topic
          user_project = self.user_projects.find{ |u_project| u_project.project_id == project.id }
          if user_project
            has_rights = true if user_project.access_level >= required_access_level
          end
        end
      end
    end
    has_rights
  end
end
