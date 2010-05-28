class ChangeDeviceToStringInUser < ActiveRecord::Migration
  def self.up
    change_column :users, :device, :string
  end

  def self.down
    change_column :users, :device, :integer
  end
end
