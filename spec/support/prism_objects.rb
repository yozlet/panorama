require 'site_prism'

class StatsSection < SitePrism::Section
  element :call_count, "#call_count .value"
end

class InvocationSection < SitePrism::Section
  # Using XPath (aargh) as a plain selector match will match all subsections too
  element :method_name,   :xpath, "div[@class='header']/span[@class='method_name']"
  element :path,          :xpath, "div[@class='header']/span[@class='path']"
  element :start_line,    :xpath, "pre[@class='body']/div[@class='start_line']"
  element :exit_line,     :xpath, "pre[@class='body']/div[@class='exit_line']"
  element :return_value,  :xpath, "div[@class='footer']/span[@class='return_value']"
  sections :children, InvocationSection, ".children"
end

class HomePage < SitePrism::Page
  set_url '/{?query*}'

  element :codepath_field, "input[name='codepath']"
  element :codepath, "#codepath"
  section :stats, StatsSection, "#stats"
  sections :invocations, InvocationSection, ".invocation"
end
