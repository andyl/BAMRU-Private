class OutboundMailSentAt < ActiveRecord::Migration[5.2]
  def up
    add_column :outbound_mails, :sent_at, :datetime
  end

  def down
    remove_column :outbound_mails, :sent_at, :datetime
  end
end
