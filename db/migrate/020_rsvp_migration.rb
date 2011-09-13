class RsvpMigration < ActiveRecord::Migration
  def change

    create_table :rsvps do |t|
      t.integer :distribution_id
      t.string   :caption
      t.string   :yes_prompt
      t.string   :no_prompt
      t.string   :maybe_prompt
      t.timestamps
    end

    create_table :rsvp_templates do |t|
      t.string   :caption
      t.string   :yes_prompt
      t.string   :no_prompt
      t.string   :maybe_prompt
      t.timestamps
    end

    create_table :rsvp_responses do |t|
      t.string   :outbound_mail_id
      t.string   :label
      t.string   :answer
      t.string   :comment
      t.timestamps
    end
  end

end