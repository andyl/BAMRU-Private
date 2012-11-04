class AddEventSupport < ActiveRecord::Migration

    def change
      create_table  :events do |t|
        t.string    :typ
        t.string    :title
        t.string    :leaders
        t.text      :description
        t.string    :location
        t.decimal   :lat, :precision => 7, :scale => 4
        t.decimal   :lon, :precision => 7, :scale => 4
        t.datetime  :start
        t.datetime  :finish
        t.boolean   :all_day,   :default => true
        t.boolean   :published, :default => false
        t.timestamps
      end

      create_table :periods do |t|
        t.integer   :event_id
        t.integer   :position
        t.datetime  :start
        t.datetime  :finish
        t.integer   :rsvp_id
        t.timestamps
      end

      create_table :participants do |t|
        t.boolean   :ol,          :default => false
        t.integer   :member_id
        t.integer   :period_id
        t.string    :comment
        t.timestamp :en_route_at
        t.timestamp :return_home_at
        t.timestamp :signed_in_at
        t.timestamp :signed_out_at
        t.timestamps
      end

      create_table :event_photos do |t|
        t.integer    :member_id
        t.integer    :event_id
        t.string     :caption
        t.string     :image_file_name
        t.string     :image_content_type
        t.integer    :image_file_size
        t.integer    :image_updated_at
        t.integer    :position
        t.boolean    :published, :default => false
        t.timestamps
      end

      add_column :data_files, :event_id,  :integer
      add_column :data_files, :caption,   :string
      add_column :data_files, :published, :boolean, :default => false

      create_table :event_links do |t|
        t.integer   :member_id
        t.integer   :event_id
        t.string    :site_url
        t.string    :caption
        t.boolean   :published, :default => false
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
