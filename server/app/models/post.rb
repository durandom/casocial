class Post < ActiveRecord::Base
  has_many :messages, :dependent => :destroy
  belongs_to :user

  acts_as_mappable :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  cattr_reader :per_page
  @@per_page = 3

  def to_xml(options = {})
    options[:except] = [:created_at, :updated_at]
    super options do |xml|
      xml.c created_at.to_i
    end
  end
end
