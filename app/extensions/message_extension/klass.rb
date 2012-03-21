module MessageExtension
  module Klass

    # Generates Rails-Ready attributes from input data.
    #
    # @param hash [Hash] We use the keys, formatted like 'email_22'
    # @return [Array] List of member hashes
    #
    # Example:
    #     hash = {'email_22': true, 'phone_44': true}
    #     distribution_params(hash) #=> [{member_id: 22, ...}]
    def distributions_params(hash)
      split_keys = hash.keys.map {|k| k.split('_')}
      int2 = split_keys.reduce({}) do |a,v|
        a[v.first] = ((a[v.first] || []) << v.last).uniq
        a
      end
      int2.keys.reduce([]) do |a,v|
        a << {:member_id => v}.merge(devices(int2[v]))
        a
      end
    end

    def mobile_distributions_params(hash)
      int1 = hash.keys.map {|k| k.split('-').last}  #array of member id's
      int1.map do |v|
        {:member_id => v, :email => true, :phone => true}
      end
    end

    private

    # Converts an array to hash.
    # Array values become hash keys.
    # Hash values are 'true'.
    #
    # @param array [Array] List of member id's
    # @return [Hash]
    #
    # Example:
    #    devices([1,2,3]) # => {1: true, 2: true, 3: true}
    def devices(array)
      array.reduce({}) do |a,v|
        a[v] = true
        a
      end
    end

  end
end