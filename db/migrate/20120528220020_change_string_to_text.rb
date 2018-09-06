class ChangeStringToText < ActiveRecord::Migration[5.2]
  def up
    change_column :messages,      :text, :text
    change_column :inbound_mails, :body, :text
  end
end
