class BaseMigration < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string   :first_name
      t.string   :last_name
      t.string   :user_name
      t.string   :typ
      t.string   :ham
      t.string   :v9
      t.boolean  :admin, :default => false
      t.string   :encrypted_password
      
      t.recoverable
      t.rememberable
      t.trackable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
      t.timestamps
    end

    # add_index :members, :email,                :unique => true
    add_index :members, :reset_password_token, :unique => true
    # add_index :members, :confirmation_token,   :unique => true
    # add_index :members, :unlock_token,         :unique => true
    # add_index :members, :authentication_token, :unique => true

    create_table :addresses do |t|
      t.integer :member_id
      t.string  :typ
      t.string  :address1,   :default => ""
      t.string  :address2,   :default => ""
      t.string  :city,       :default => ""
      t.string  :state,      :default => ""
      t.string  :zip,        :default => ""
      t.integer :position
      t.timestamps
    end
    create_table :phones do |t|
      t.integer :member_id
      t.string  :typ
      t.string  :number
      t.string  :pagable
      t.integer :position
      t.timestamps
    end
    create_table :emails do |t|
      t.integer :member_id
      t.string  :typ
      t.string  :pagable
      t.string  :address
      t.integer :position
      t.timestamps
    end
    create_table :roles do |t|
      t.string :member_id
      t.string :typ
      t.timestamps
    end
    create_table :photos do |t|
      t.integer    :member_id
      t.string     :image_file_name
      t.string     :image_content_type
      t.integer    :image_file_size
      t.integer    :image_updated_at
      t.integer    :position
      t.timestamps
    end
    create_table :certs do |t|
      t.integer    :member_id
      t.string     :typ
      t.date       :expiration
      t.string     :doc_file
      t.string     :description
      t.string     :comment
      t.string     :link
      t.string     :document_file_name
      t.string     :document_content_type
      t.string     :document_file_size
      t.string     :document_updated_at
      t.timestamps
    end
    create_table :emergency_contacts do |t|
      t.integer   :member_id
      t.string    :name
      t.string    :number
      t.string    :typ
      t.integer   :position
    end
    create_table :other_infos do |t|
      t.integer   :member_id
      t.string    :label
      t.string    :value
      t.integer   :position
    end
    create_table :avail_ops do |t|
      t.integer   :member_id
      t.date      :start
      t.date      :end
      t.string    :comment
      t.timestamps
    end
    create_table :avail_dos do |t|
      t.integer      :member_id
      t.integer      :year
      t.integer      :quarter
      t.integer      :week
      t.string       :typ
      t.string       :comment
      t.timestamps
    end
    create_table :orgs do |t|
      t.string       :name
    end
    create_table :do_assignments do |t|
      t.integer      :org_id
      t.integer      :year
      t.integer      :quarter
      t.integer      :week
      t.string       :name
      t.timestamps
    end
    create_table :messages do |t|
      t.integer       :author_id
      t.string        :ip_address
      t.string        :text
      t.timestamps
    end
    create_table :distributions do |t|
      t.integer       :message_id
      t.integer       :member_id
      t.boolean       :email,    :default => false
      t.boolean       :phone,    :default => false
      t.timestamps
    end
  end

end
