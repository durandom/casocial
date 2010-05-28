class AddInReplyToUserIdToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :in_reply_to_user_id, :integer
  end

  def self.down
    remove_column :messages, :in_reply_to_user_id
  end
end
