class AddCategoryToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :category, :integer
  end

  def self.down
    remove_column :posts, :category
  end
end
