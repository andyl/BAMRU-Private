require 'time'

class DoHandoff < ActiveRecord::Base

  # ----- Associations -----
  belongs_to :outgoing_do, :class_name => 'Member', :foreign_key => 'outgoing_do_id'
  belongs_to :incoming_do, :class_name => 'Member', :foreign_key => 'incoming_do_id'
  belongs_to :created_by,  :class_name => 'Member', :foreign_key => 'created_by_id'

  # ----- Callbacks -----
  before_validation :initialize_object
  after_create      :abandon_old_handoff

  # ----- Validations -----
  validates_format_of :status, :with => /^(started|finished|abandoned)$/
  validates_presence_of :incoming_do_id
  validates_presence_of :outgoing_do_id

  # ----- Scopes -----
  scope :started,   where(:status => "started")
  scope :finished,  where(:status => "finished")
  scope :abandoned, where(:status => "abandoned")
  scope :not_id,    lambda {|id| where('id != ?', id) }

  # ----- Class Methods -----

  # ----- Local Methods-----
  def initialize_object
    self.started_at = Time.now   if self.started_at.nil?
    self.status     = "started"  if self.status.nil?
  end

  def abandon_old_handoff
    if obj = DoHandoff.started.not_id(self.id).first
      obj.update_attributes({:status => "abandoned"})
    end
  end

  def send_start_notice
    params = base_params
    params['text'] = "Message Here"
    params['distributions_attributes'] = [{'member_id' => incoming_do_id, 'phone' => false, 'email' => true}]
    m = Message.create(np)
    call_rake('ops:email:send_distribution', {:message_id => m.id}) unless %w(development test).include? ENV['RAILS_ENV']
  end

  def send_reminder_notice
    params = base_params
    params['text'] = "Message Here"
    params['distributions_attributes'] = [{'member_id' => incoming_do_id, 'phone' => false, 'email' => true}]
    m = Message.create(np)
    call_rake('ops:email:send_distribution', {:message_id => m.id}) unless %w(development test).include? ENV['RAILS_ENV']
  end

  def send_finish_notice
    params = base_params
    params['text'] = "Message Here"
    params['distributions_attributes'] = [{'member_id' => incoming_do_id, 'phone' => false, 'email' => true}]
    m = Message.create(np)
    call_rake('ops:email:send_distribution', {:message_id => m.id}) unless %w(development test).include? ENV['RAILS_ENV']
  end

  private

  def base_params
    params = {}
    params['author_id']  = Member.find_or_create_by_user_name("automatic_pager").id
    params['ip_address'] = "NA"
    params
  end

end


# == Schema Information
#
# Table name: do_handoffs
#
#  id                 :integer         not null, primary key
#  outgoing_do_id     :integer
#  incoming_do_id     :integer
#  created_by_id      :integer
#  status             :string(255)
#  started_at         :datetime
#  finished_at        :datetime
#  next_reminder_time :datetime
#  num_reminders      :integer
#  created_at         :datetime
#  updated_at         :datetime
#

