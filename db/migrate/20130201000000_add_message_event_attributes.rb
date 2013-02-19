class AddMessageEventAttributes < ActiveRecord::Migration

    def change

      add_column :messages, :period_id,       :integer
      add_column :messages, :period_format,   :string

    end

end
