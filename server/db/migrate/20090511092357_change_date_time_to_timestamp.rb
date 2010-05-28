class ChangeDateTimeToTimestamp < ActiveRecord::Migration
  def self.up
    change_column :messages, :created_at, :timestamp
  end

  def self.down
    change_column :messages, :created_at, :datetime
  end
end
