class RolesMemberIdToInteger < ActiveRecord::Migration
  def up
    change_column :roles, :member_id, :integer
  end
end
