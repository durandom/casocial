class Message < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :in_reply_to_user, :class_name => 'User'

  def to_xml(options = {})
    options[:except] = [:created_at]
    super options do |xml|
      xml.c created_at.to_i
    end
  end
end
