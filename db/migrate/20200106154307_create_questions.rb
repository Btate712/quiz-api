class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :topic_id
      t.text :stem
      t.text :choice_1
      t.text :choice_2
      t.text :choice_3
      t.text :choice_4
      t.integer :correct_choice
      t.string :image_url

      t.timestamps
    end
  end
end
