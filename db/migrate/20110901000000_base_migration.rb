class BaseMigration < ActiveRecord::Migration
  def change
    create_table  :members do |t|
      t.string    :title
      t.string    :first_name
      t.string    :last_name
      t.string    :user_name
      t.string    :typ
      t.string    :ham
      t.string    :v9
      t.boolean   :admin,     :default => false
      t.boolean   :developer, :default => false

      t.integer   :role_score
      t.integer   :typ_score

      t.string    :password_digest

      t.integer   :sign_in_count, :default => 0
      t.time      :last_sign_in_at
      t.string    :ip_address

      t.string    :remember_me_token

      t.string    :forgot_password_token
      t.datetime  :forgot_password_expires_at

      t.string    :google_oauth_token

      t.time      :remember_created_at

      t.timestamps
    end

    add_index :members, :forgot_password_token, :unique => true

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
      t.string  :sms_email
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
      t.string     :description
      t.string     :comment
      t.string     :link
      t.integer    :position
      t.string     :cert_file
      t.string     :cert_file_name
      t.string     :cert_content_type
      t.string     :cert_file_size
      t.string     :cert_updated_at
      t.timestamps
    end
    create_table :data_files do |t|
      t.integer    :member_id
      t.integer    :download_count,   :default => 0
      t.string     :data_file_extension
      t.string     :data_file_name
      t.string     :data_file_size
      t.string     :data_content_type
      t.string     :data_updated_at
      t.timestamps
    end
    create_table :emergency_contacts do |t|
      t.integer   :member_id
      t.string    :name
      t.string    :number
      t.string    :typ
      t.integer   :position
      t.timestamps
    end
    create_table :other_infos do |t|
      t.integer   :member_id
      t.string    :label
      t.string    :value
      t.integer   :position
      t.timestamps
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
      t.integer      :org_id,     :default => 1
      t.integer      :year
      t.integer      :quarter
      t.integer      :week
      t.string       :name
      t.timestamps
    end
    create_table :chats do |t|
      t.integer       :member_id
      t.string        :client # browser | mobile
      t.string        :lat
      t.string        :lon
      t.string        :ip_address
      t.string        :text
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
      t.boolean       :read,     :default => false
      t.boolean       :bounced,  :default => false
      t.datetime      :read_at
      t.integer       :response_seconds
      t.boolean       :rsvp,     :default => false
      t.string        :rsvp_answer
      t.timestamps
    end
    create_table :outbound_mails do |t|
      t.integer  :distribution_id
      t.integer  :email_id
      t.integer  :phone_id
      t.string   :address
      t.string   :label
      t.boolean  :read,    :default => false
      t.boolean  :bounced, :default => false
      t.timestamps
    end
    create_table :inbound_mails do |t|
      t.integer  :outbound_mail_id
      t.string   :from
      t.string   :to
      t.string   :uid
      t.string   :subject
      t.string   :label
      t.string   :body
      t.string   :rsvp_answer
      t.datetime :send_time
      t.boolean  :bounced, :default => false
      t.timestamps
    end
    create_table :journals do |t|
      t.integer :member_id
      t.integer :distribution_id
      t.string  :action
      t.timestamps
    end
    create_table :rsvp_templates do |t|
      t.integer :position
      t.string  :name
      t.string  :prompt
      t.string  :yes_prompt
      t.string  :no_prompt
      t.timestamps
    end
    create_table :rsvps do |t|
      t.integer :message_id
      t.string  :prompt
      t.string  :yes_prompt
      t.string  :no_prompt
      t.timestamps
    end

  end

end
