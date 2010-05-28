class AddSerialToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :serial, :int
  end

  def self.down
    remove_column :posts, :serial
  end
end
