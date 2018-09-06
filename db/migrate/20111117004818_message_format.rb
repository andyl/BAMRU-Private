class MessageFormat < ActiveRecord::Migration[5.2]
  def up
    add_column :messages, :format, :string
  end

  def down
    remove_column :messages, :format, :string
  end
end
