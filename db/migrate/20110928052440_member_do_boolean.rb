class MemberDoBoolean < ActiveRecord::Migration
  def up
    add_column :members, :current_do, :boolean, :default => false
  end

  def down
    remove_column :members, :current_do, :boolean
  end
end
