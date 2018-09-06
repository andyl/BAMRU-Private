class DoAssignmentUpdate < ActiveRecord::Migration[5.2]
  def up
    add_column :do_assignments, :primary_id, :integer
    add_column :do_assignments, :backup_id,  :integer
    add_column :do_assignments, :start,      :datetime
    add_column :do_assignments, :finish,     :datetime

    DoAssignment.all.each do |assignment|
      search_name = assignment.name.split(' ').join(' ').gsub(' ', '_').downcase
      if member = Member.where(:user_name => search_name).try(:first)
        date = "#{assignment.year}/#{assignment.quarter}/#{assignment.week}"
        puts "Updating #{assignment.name} for #{date}"
        assignment.primary_id = member.id
        assignment.save
      end
    end

    DoAssignment.all.each do |assignment|
      assignment.start  = assignment.start_time
      assignment.finish = assignment.end_time
      assignment.save
    end

  end

  def down
    remove_column :do_assignments, :primary_id, :integer
    remove_column :do_assignments, :backup_id,  :integer
    remove_column :do_assignments, :start,      :datetime
    remove_column :do_assignments, :finish,     :datetime
  end
end
