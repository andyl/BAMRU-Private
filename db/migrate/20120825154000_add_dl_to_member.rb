class AddDlToMember < ActiveRecord::Migration
  def change
    add_column :members, :dl, :string
  end
end
