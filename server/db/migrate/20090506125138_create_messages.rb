class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
