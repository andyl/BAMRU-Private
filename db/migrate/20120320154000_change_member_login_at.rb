class ChangeMemberLoginAt < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :members, :last_sign_in_at
    add_column    :members, :last_sign_in_at, :datetime
  end

  def self.down
    add_column    :members, :last_sign_in_at, :time
    remove_column :members, :last_sign_in_at
  end
end
