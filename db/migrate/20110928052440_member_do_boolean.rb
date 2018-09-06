class MemberDoBoolean < ActiveRecord::Migration[5.2]
  def up
    add_column :members, :current_do, :boolean, :default => false
  end

  def down
    remove_column :members, :current_do, :boolean
  end
end
