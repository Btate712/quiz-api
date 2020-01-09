class CreateProjectTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :project_topics do |t|
      t.integer :project_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
