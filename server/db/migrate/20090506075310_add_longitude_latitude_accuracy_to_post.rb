class AddLongitudeLatitudeAccuracyToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :longitude, :float
    add_column :posts, :latitude, :float
    add_column :posts, :accuracy, :int
  end

  def self.down
    remove_column :posts, :accuracy
    remove_column :posts, :latitude
    remove_column :posts, :longitude
  end
end
