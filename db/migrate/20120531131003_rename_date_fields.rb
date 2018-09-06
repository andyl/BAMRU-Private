class RenameDateFields < ActiveRecord::Migration[5.2]
  def up
    rename_column :avail_ops, :start, :start_on
    rename_column :avail_ops, :end,   :end_on
  end


  def down
    rename_column :avail_ops, :start_on, :start
    rename_column :avail_ops, :end_on,   :end
  end
end
