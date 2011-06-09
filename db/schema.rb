# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 10) do

  create_table "addresses", :force => true do |t|
    t.integer  "member_id"
    t.string   "typ"
    t.string   "address1",   :default => ""
    t.string   "address2",   :default => ""
    t.string   "city",       :default => ""
    t.string   "state",      :default => ""
    t.string   "zip",        :default => ""
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avail_dos", :force => true do |t|
    t.integer  "member_id"
    t.integer  "year"
    t.integer  "quarter"
    t.integer  "week"
    t.integer  "typ"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avail_ops", :force => true do |t|
    t.integer  "member_id"
    t.date     "start"
    t.date     "end"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certs", :force => true do |t|
    t.integer  "member_id"
    t.string   "typ"
    t.date     "expiration"
    t.string   "doc_file"
    t.string   "description"
    t.string   "comment"
    t.string   "link"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.string   "document_file_size"
    t.string   "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distributions", :force => true do |t|
    t.integer  "message_id"
    t.integer  "member_id"
    t.boolean  "email",      :default => false
    t.boolean  "phone",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "do_assignments", :force => true do |t|
    t.integer  "year"
    t.integer  "quarter"
    t.integer  "week"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.integer  "member_id"
    t.string   "typ"
    t.string   "pagable"
    t.string   "address"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emergency_contacts", :force => true do |t|
    t.integer "member_id"
    t.string  "name"
    t.string  "number"
    t.string  "typ"
    t.integer "position"
  end

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.string   "typ"
    t.string   "ham"
    t.string   "v9"
    t.boolean  "admin",                  :default => false
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "author_id"
    t.string   "ip_address"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "other_infos", :force => true do |t|
    t.integer "member_id"
    t.string  "label"
    t.string  "value"
    t.integer "position"
  end

  create_table "phones", :force => true do |t|
    t.integer  "member_id"
    t.string   "typ"
    t.string   "number"
    t.string   "pagable"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "member_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "image_updated_at"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "member_id"
    t.string   "typ"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
