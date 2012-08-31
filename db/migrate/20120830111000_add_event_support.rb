class AddEventSupport < ActiveRecord::Migration

    def change
      create_table  :events do |t|
        t.string    :title
        t.string    :description
        t.integer   :leader
        t.integer   :lat
        t.integer   :lon
        t.datetime  :start
        t.datetime  :end
        t.string    :type
        t.timestamps
      end

      create_table :phases do |t|
        t.string    :title
        t.integer   :event_id
        t.integer   :participant_id
        t.timestamps
      end

      create_table :participants do |t|
        t.integer   :member_id
        t.integer   :phase_id
        t.timestamps
      end

      create_table :event_photos do |t|
        t.integer   :event_id
        t.integer   :photo_id
        t.timestamps
      end

      create_table :event_files do |t|
        t.integer   :event_id
        t.integer   :file_id
        t.timestamps
      end

      create_table :event_pages do |t|
        t.integer   :event_id
        t.integer   :page_id
        t.timestamps
      end

      add_column :members, :dl, :string

    end

end
