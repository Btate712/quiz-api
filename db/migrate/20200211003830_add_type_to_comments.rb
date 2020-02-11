class AddTypeToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :comment_type, :string
  end
end
