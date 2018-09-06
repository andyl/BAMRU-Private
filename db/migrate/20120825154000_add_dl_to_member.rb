class AddDlToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :dl, :string
  end
end
