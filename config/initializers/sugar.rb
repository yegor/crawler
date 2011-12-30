def returning(value)
  yield(value)
  value
end

AppStore::ChartEntry
AppStore::LookupEntry

class ActiveRecord::Base
  
  #  Updates self with the attributes that sutes
  #
  #  * <tt>attributes</tt>:: +Hash+ hash of attributes to update with
  #
  def smart_update_attributes(attributes = {})
    sutable_attributes = attributes.inject({}) do |result, (key, value)|
      result[key] = value if self.respond_to? key
      result
    end
    
    self.update_attributes sutable_attributes
  end
  
  def smart_assign_attributes(attrs)
    attrs.each do |key, value|
      send(key.to_s + "=", value) if self.respond_to? key
    end
  end
end

class Time
  def beginning_of_hour
    change(:min => 0, :sec => 0, :usec => 0)
  end
end