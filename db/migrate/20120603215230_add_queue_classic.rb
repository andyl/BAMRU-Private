require 'queue_classic'

class AddQueueClassic < ActiveRecord::Migration[5.2]
  def up
    QC::Setup.create
  # create_table "queue_classic_jobs", :force => true do |t|
  #   t.string   "q_name"
  #   t.string   "method"
  #   t.text     "args"
  #   t.datetime "locked_at"
  # end
  #
  # add_index "queue_classic_jobs", ["q_name", "id"], :name => "idx_qc_on_name_only_unlocked"
  #
  end

  def down
    QC::Setup.drop
  end
end
