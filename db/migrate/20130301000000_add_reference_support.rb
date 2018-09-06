class AddReferenceSupport < ActiveRecord::Migration[5.2]

    def change

      # ----- files -----

      create_table :event_files do |t|
        t.integer :event_id
        t.integer :data_file_id
        t.text    :keyval
        t.timestamps
      end

      # renaming to make this operation reversible...
      rename_column :data_files, :position, :killme1
      rename_column :data_files, :event_id, :killme2

      # ----- photos -----

      drop_table :event_photos

      create_table :event_photos do |t|
        t.integer :event_id
        t.integer :data_photo_id
        t.text    :keyval
        t.timestamps
      end

      create_table :data_photos do |t|
        t.integer    :member_id
        t.string     :caption
        t.string     :image_file_name
        t.string     :image_content_type
        t.integer    :image_file_size
        t.integer    :image_updated_at
        t.integer    :position
        t.boolean    :published, :default => false
        t.timestamps
      end

      # ----- links -----

      drop_table :event_links

      create_table :event_links do |t|
        t.integer :event_id
        t.integer :data_link_id
        t.text    :keyval
        t.timestamps
      end

      create_table :data_links do |t|
        t.integer   :member_id
        t.string    :site_url
        t.string    :caption
        t.boolean   :published, :default => false
        t.string    :link_backup_file_name
        t.string    :link_backup_content_type
        t.integer   :link_backup_file_size
        t.integer   :link_backup_updated_at
        t.integer   :position
        t.timestamps
      end

    end

end
