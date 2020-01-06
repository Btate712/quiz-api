class CreateUserTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :user_topics do |t|
      t.integer :user_id
      t.integer :topic_id
      t.integer :access_level

      t.timestamps
    end
  end
end
