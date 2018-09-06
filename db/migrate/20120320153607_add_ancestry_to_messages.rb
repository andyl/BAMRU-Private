class AddAncestryToMessages < ActiveRecord::Migration[5.2]
  def self.up
    add_column :messages, :linked_rsvp_id, :integer
    add_column :messages, :ancestry, :string
    add_index  :messages, :ancestry
  end

  def self.down
    remove_index  :messages, :ancestry
    remove_column :messages, :ancestry
    remove_column :messages, :linked_rsvp_id, :integer
  end
end
