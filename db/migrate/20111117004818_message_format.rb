class MessageFormat < ActiveRecord::Migration
  def up
    add_column :messages, :format, :string
  end

  def down
    remove_column :messages, :format, :string
  end
end
