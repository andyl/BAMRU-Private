class RolesMemberIdToInteger < ActiveRecord::Migration[5.2]
  def up
    change_column :roles, :member_id, :integer
  end
end
