class AddReferenceSupport < ActiveRecord::Migration

    def change

      create_table :event_files do |t|
        t.integer :event_id
        t.integer :data_file_id
        t.timestamps
      end

      # renaming to make this operation reversible...
      # remove_column :data_files, :position
      rename_column :data_files, :position, :killme1
      rename_column :data_files, :event_id, :killme2

    end

end
