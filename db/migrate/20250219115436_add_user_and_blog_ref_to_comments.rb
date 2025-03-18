class AddUserAndBlogRefToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :blogs, null: false, foreign_key: true
    add_reference :comments, :users, null: false, foreign_key: true
  end
end
