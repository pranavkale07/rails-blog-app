class RenameColumnsInComments < ActiveRecord::Migration[8.0]
  def change
    rename_column :comments, :blogs_id, :blog_id
    rename_column :comments, :users_id, :user_id
  end
end
