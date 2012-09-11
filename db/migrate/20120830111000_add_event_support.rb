class AddEventSupport < ActiveRecord::Migration

    def change
      create_table  :events do |t|
        t.string    :typ
        t.string    :title
        t.text      :description
        t.string    :location
        t.decimal   :lat, :precision => 10, :scale => 6
        t.decimal   :lon, :precision => 10, :scale => 6
        t.datetime  :start
        t.datetime  :finish
        t.boolean   :public, :default => false
        t.timestamps
      end

      create_table :leaders do |t|
        t.integer :member_id
        t.integer :event_id
        t.integer :position
        t.timestamps
      end

      create_table :periods do |t|
        t.string    :title
        t.integer   :event_id
        t.integer   :position
        t.datetime  :start
        t.datetime  :finish
osostype        t.timestamps
      end

      create_table :participants do |t|
        t.string    :role
        t.integer   :member_id
        t.integer   :period_id
        t.timestamp :start
        t.timestamp :finish
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
        t.integer   :position
        t.timestamps
      end

      create_table :period_pages do |t|
        t.integer   :period_id
        t.integer   :page_id
        t.timestamps
      end

      create_table :browser_profiles do |t|
        t.integer :member_id
        t.string  :ip
        t.string  :browser_type
        t.string  :browser_version
        t.string  :user_agent
        t.string  :ostype
        t.boolean :javascript
        t.boolean :cookies
        t.integer :screen_height
        t.integer :screen_width
        t.timestamps
      end

      #add_column :members, :dl, :string

    end

end
