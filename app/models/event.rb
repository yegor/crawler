class Event
  
  attr_accessor :type
  attr_accessor :description
  attr_accessor :game
  
  class << self
    
    #  Returns a hash of things like game => {date => event} to be nicely displayed
    #  on the chart.
    #
    #  * <tt>rankings</tt>:: A +Hash+ taken from +Stats+ model.
    #
    def collect_events_over(rankings)
      result = {}
      
      
      
      result
    end
    
  end
  
end