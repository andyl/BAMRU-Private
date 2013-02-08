class AddMessageEventAttributes < ActiveRecord::Migration

    def change

      add_column :messages, :period_id,       :integer
      add_column :messages, :period_msg_typ,  :string

    end

end
