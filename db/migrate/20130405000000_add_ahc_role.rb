class AddAhcRole < ActiveRecord::Migration

    def change

      add_column :participants, :ahc, :boolean, :default => false

    end

end
