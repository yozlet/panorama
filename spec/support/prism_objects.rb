require 'site_prism'

class StatsSection < SitePrism::Section
  element :call_count, "#call_count .value"
end

class InvocationSection < SitePrism::Section
  element :method_name,   ".method_name"
  element :path,          ".path"
  element :start_line,    ".start_line"
  element :exit_line,     ".exit_line"
  element :return_value,  ".return_value"
end

class HomePage < SitePrism::Page
  set_url '/{?query*}'
  
  element :codepath_field, "input[name='codepath']"
  element :codepath, "#codepath"
  section :stats, StatsSection, "#stats"  
  sections :invocations, InvocationSection, ".invocation"  
end
