class AddDetailsToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :details, :string
  end

  def self.down
    remove_column :posts, :details
  end
end
