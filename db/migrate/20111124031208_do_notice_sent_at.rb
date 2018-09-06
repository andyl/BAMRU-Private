class DoNoticeSentAt < ActiveRecord::Migration[5.2]
  def up
    add_column :do_assignments, :reminder_notice_sent_at, :datetime
    add_column :do_assignments, :alert_notice_sent_at,    :datetime
  end

  def down
    remove_column :do_assignments, :reminder_notice_sent_at, :datetime
    remove_column :do_assignments, :alert_notice_sent_at,    :datetime
  end
end
