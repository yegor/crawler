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
end