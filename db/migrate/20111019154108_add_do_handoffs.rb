class AddDoHandoffs < ActiveRecord::Migration
  def change
    create_table :do_handoffs do |t|
      t.string   :typ                  # 'scheduled' or 'mid-week'
      t.integer  :incoming_do_id
      t.integer  :created_by_id
      t.string   :status               # 'started' or 'finished'
      t.datetime :finished_at
      t.timestamps
    end
  end

end
