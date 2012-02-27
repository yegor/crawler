class Event
  
  attr_accessor :type
  attr_accessor :description
  attr_accessor :label
  
  class << self
    
    #  Returns a hash of things like game => {date => event} to be nicely displayed
    #  on the chart.
    #
    #  * <tt>hours</tt>:: A range of dates to iterate over.
    #  * <tt>countries</tt>:: An array of countries to inspect.
    #  * <tt>imports</tt>:: An array of imports to inspect.
    #  * <tt>itunes_id</tt>:: itunes_id to inspect.
    #
    def collect_events_over(hours, countries, imports, itunes_id)
      result = {}
      
      imports_by_id = imports.index_by(&:id)
      imports_by_hour = imports.index_by { |i| i.created_at.to_time.beginning_of_hour }
      
      featurings = FeaturingSnapshot.where(:import_id => imports_by_id.keys, :country => countries, :itunes_id => itunes_id).
                   joins("INNER JOIN featurings ON featurings.id = featuring_snapshots.featuring_id").
                   joins("INNER JOIN pages ON pages.id = featurings.page_id").
                   select("featuring_snapshots.import_id as import_id, featurings.type as featuring_type, pages.title as page_title, pages.type as page_type").group_by(&:import_id)
                   
      last_featuring = ""
      
      hours.each do |hour|
        current_featuring = (featurings[ imports_by_hour[ hour ].try(:id) ] || []).map { |f| "#{f.featuring_type.split(":").last} on #{f.page_title}" }.join(", ")
        
        if (last_featuring != current_featuring)
          result[ hour ]  = Event.new.tap do |e|
            e.description = current_featuring.blank? ? "Not featured anymore" : "Featured as #{current_featuring}"
            e.label = (result.size + "a".ord).chr.upcase
            
            last_featuring = current_featuring
          end
        end
      end
      
      result
    end
    
  end
  
end