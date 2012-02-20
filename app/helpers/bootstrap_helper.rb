module BootstrapHelper
  
  #  Renders a bootstrap dropdown layout.
  #
  #  * <tt>field</tt>:: Field name to use.
  #  * <tt>choices</tt>:: Available choices, either an Array or Hash (key is value to send).
  #  * <tt>options</tt>:: Options to use. Keys include :value, :multiple.
  #
  def bootstrap_dropdown(field, choices, options = {})
    choices = choices.inject({}) { |memo, v| memo.merge(v => v) } unless choices.is_a?(Hash)
    display_value = if options[:multiple]
      (options[:value] || []).map { |v| choices[v] }.join(", ")
    else
      choices[ options[:value] ]
    end
    display_value = options[:display_value] if options[:display_value].present?
    
    render("/common/bootstrap_dropdown", :field => field, :choices => choices, :multiple => options[:multiple], 
                                         :selected_values => options[:value], :display_value => display_value)
  end
  
end