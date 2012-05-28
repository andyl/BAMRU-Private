class ChangeStringToText < ActiveRecord::Migration
  def up
    change_column :messages,      :text, :text
    change_column :inbound_mails, :body, :text
  end
end
