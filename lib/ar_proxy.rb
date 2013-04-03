# see http://railscasts.com/episodes/219-active-model
# see http://railscasts.com/episodes/326-activeattr
# see https://github.com/6twenty/modest_model

require 'forwardable'

class ArProxy < ModestModel::Base

  extend Forwardable

  def self.proxy_attributes(opts)
    # create setters for proxy objects
    opts.keys.each do |key|
      sym = "#{key.to_s[1..-1]}".to_sym
      attr_accessor sym
    end
    # setup data methods
    opts.each do |proxy_obj, attrs|
      attrs.each do |attr_setter|
        attr_getter = "#{attr_setter.to_s}=".to_sym
        attributes attr_setter
        def_delegator proxy_obj, attr_setter, attr_setter
        def_delegator proxy_obj, attr_getter, attr_getter
      end
    end
  end

  def as_json(_opts = {})
    attributes
  end

  def update_attributes(attributes)
    assign_attributes(attributes)
    save
  end

  def self.create(params)
    obj = self.new(params)
    obj.save
    obj
  end

  private

  def assign_attributes(attrs)
    attrs.each { |key, val| send "#{key}=", val } unless attrs.blank?
  end

end