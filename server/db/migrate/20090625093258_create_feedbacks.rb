class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.string :body
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
