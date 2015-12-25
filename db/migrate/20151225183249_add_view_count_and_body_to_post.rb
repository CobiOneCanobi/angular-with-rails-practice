class AddViewCountAndBodyToPost < ActiveRecord::Migration
  def change
    add_column :posts, :viewed, :integer
    add_column :posts, :body, :text
  end
end
