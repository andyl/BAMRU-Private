class InboundMailIgnoreBounce < ActiveRecord::Migration
  def up
    add_column :inbound_mails, :ignore_bounce, :boolean, :default => false
  end

  def down
    remove_column :inbound_mails, :ignore_bounce, :boolean
  end
end
