class AddSerialToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :serial, :int
  end

  def self.down
    remove_column :messages, :serial
  end
end
