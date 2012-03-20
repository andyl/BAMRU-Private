module MessageExtension
  module Klass

    def devices(array)
      array.reduce({}) do |a,v|
        a[v] = true
        a
      end
    end

    def distributions_params(hash)
      int1 = hash.keys.map {|k| k.split('_')}
      int2 = int1.reduce({}) do |a,v|
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

  end
end