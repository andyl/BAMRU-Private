class RenameDateFields < ActiveRecord::Migration
  def up
    rename_column :avail_ops, :start, :start_on
    rename_column :avail_ops, :end, :end_on
  end
end
