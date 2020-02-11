class AddTypeToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :type, :string
  end
end
