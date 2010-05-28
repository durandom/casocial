class ChangeBodiesToText < ActiveRecord::Migration
  def self.up
    change_column :feedbacks, :body, :text
    change_column :messages, :body, :text
    change_column :posts, :body, :text
  end

  def self.down
    change_column :feedbacks, :body, :string
    change_column :messages, :body, :string
    change_column :posts, :body, :string
  end
end
