class OutboundMailSentAt < ActiveRecord::Migration
  def up
    add_column :outbound_mails, :sent_at, :datetime
  end

  def down
    remove_column :outbound_mails, :sent_at, :datetime
  end
end
