class ChangeDetailsToBody < ActiveRecord::Migration
  def self.up
    rename_column(:posts, :details, :body)
    rename_column(:messages, :message, :body)
  end

  def self.down
    rename_column(:posts, :body, :details)
    rename_column(:messages, :body, :message)
  end
end
