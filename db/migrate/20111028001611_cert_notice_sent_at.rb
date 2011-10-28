class CertNoticeSentAt < ActiveRecord::Migration
  def up
    add_column :certs, :ninety_day_notice_sent_at, :datetime
    add_column :certs, :thirty_day_notice_sent_at, :datetime
    add_column :certs, :expired_notice_sent_at,    :datetime
  end

  def down
    remove_column :certs, :ninety_day_notice_sent_at, :datetime
    remove_column :certs, :thirty_day_notice_sent_at, :datetime
    remove_column :certs, :expired_notice_sent_at,    :datetime
  end
end
