class AddDeviceIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :apn_device_id, :integer
  end

  def self.down
    remove_column :users, :apn_device_id
  end
end
