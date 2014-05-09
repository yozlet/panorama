require 'site_prism'

class StatsSection < SitePrism::Section
  element :call_count, "#call_count .value"
end

class HomePage < SitePrism::Page
  set_url '/{?query*}'
  
  element :codepath_field, "input[name='codepath']"
  element :codepath, "#codepath"
  section :stats, StatsSection, "#stats"  
end
