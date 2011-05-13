class BaseMigration < ActiveRecord::Migration
  # tables...
  # user, address, phone, role, photo, email, 
  # mpa (member personal availabliity) , doa (duty officer availability)
  # page_log
  def self.up
    create_table :users do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :login
      # t.string  :email
      t.string  :member_type
      t.boolean :admin, :default => false
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
      t.timestamps
    end
#    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    create_table :addresses do |t|
      t.integer :user_id
      t.string  :atype
      t.string  :addr1
      t.string  :addr2
      t.string  :city
      t.string  :state
      t.string  :zip
      t.timestamps
    end
    create_table :phones do |t|
      t.integer :user_id
      t.string  :ptype
      t.string  :number
      t.string  :pagable
      t.timestamps
    end
    create_table :emails do |t|
      t.integer :user_id
      t.string  :etype
      t.string  :address
      t.timestamps
    end
    create_table :roles do |t|
      t.timestamps
    end
    create_table :photos do |t|
      t.integer    :user_id
      t.string     :filename
      t.timestamps
    end
    create_table :oots do |t|
      t.integer   :user_id
      t.date      :start
      t.date      :end
      t.timestamps
    end
    create_table :do_avails do |t|
      t.integer      :userid
      t.integer      :week
      t.string       :status
      t.timestamps
    end
    create_table :do_assignments do |t|
      t.integer       :user_id
      t.timestamps
    end
    create_table :messages do |t|
      t.integer       :user_id         # author
      t.string        :contents
      t.timestamps
    end
    create_table :distributions do |t|
      t.integer      :user_id
      t.integer      :message_id
    end
  end
end
