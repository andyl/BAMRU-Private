class AddReferenceSupport < ActiveRecord::Migration

    def change

      create_table :event_files do |t|
        t.integer :event_id
        t.integer :data_file_id
        t.text    :caption
      end

      # renaming to make this operation reversible...
      # remove_column :data_files, :position
      rename_column :data_files, :position, :killme1
      rename_column :data_files, :event_id, :killme2
      rename_column :data_files, :caption,  :killme3

    end

end
