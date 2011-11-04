# The mail servers of many SMS gateways treat email as spam if the messages
# arrive too frequently.  This has happened using the SMS-gateways managed
# by Verizon, Sprint, and other carriers.
#

# Maintains a queue of delivery addresses for a given carrier.
# Limits the sending frequency, to reduce the chance of being rejected as spam.
#
class CarrierQueue

  def self.time_delay_per_carrier
    8 # seconds
  end

  def time_delay_per_message
    0.33 # seconds
  end

  def initialize
    @address_queue = []
    @wait_time     = nil
  end

  def count
    @address_queue.count
  end

  def add(address_object)
    @address_queue << address_object
  end

  def get
    sleep time_delay_per_message
    return nil unless get_able?
    @wait_time = Time.now + time_delay_per_message
    @address_queue.pop
  end

  def get_able?
    return false if @address_queue.empty?
    return false unless @wait_time.nil? || Time.now > @wait_time
    true
  end

end

# Maintains a collection of CarrierQueues.  Orders the queues for maximum
# sending efficiency, given the built-in time delay for each carrier.
#
#  Simple Test Example using load_all / get_all:
#    collection = CarrierQueueCollection.new
#    collection.load_all(Phone)
#    collection.get_all
#
#  Example: sending email messages to selected members
#    collection = CarrierQueueCollection.new
#    collection.load_all(Phone.where(:member_id => [1,3,4,5]))
#    message = "example pager message"
#    while phone_object = collection.get
#      Mail.send(message, phone_object)
#    end
#
class CarrierQueueCollection

  def initialize
    @queue_hash = {}
  end

  def add(address_object)
    carrier = address_object.email_org
    return if carrier.blank?
    @queue_hash[carrier] = CarrierQueue.new if @queue_hash[carrier].nil?
    @queue_hash[carrier].add(address_object)
  end

  def load_all(class_name)
    class_name.pagable.all.each {|address_object| add(address_object)}
  end
  
  def get_all
    while address_object = get
      puts address_object.email_address
    end
  end

  def get
    remove_empty_queues_from_hash
    return nil if @queue_hash.empty?
    queues = sort_queues_by_count
    queue  = find_valid_queue(queues)
    queue.get
  end

  private

  def find_valid_queue(queue_list)
    first_valid_queue = nil
    while first_valid_queue.nil?  # loop until the wait_time has expired...
      sleep 0.1
      first_valid_queue = queue_list.find { |q| q.get_able? }
    end
    first_valid_queue
  end

  def sort_queues_by_count
    @queue_hash.values.sort {|x,y| y.count <=> x.count}
  end

  def remove_empty_queues_from_hash
    @queue_hash.delete_if {|k,v| v.count == 0 }
  end

end