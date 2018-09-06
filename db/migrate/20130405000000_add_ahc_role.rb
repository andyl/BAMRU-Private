class AddAhcRole < ActiveRecord::Migration[5.2]

    def change

      add_column :participants, :ahc, :boolean, :default => false

    end

end
