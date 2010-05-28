class User < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
  has_many :messages
  belongs_to :apn_device, :class_name => 'APN::Device'
end
