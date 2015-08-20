require 'site_prism'

class StatsSection < SitePrism::Section
  element :call_count, "#call_count .value"
end

class InvocationSection < SitePrism::Section
  element :method_name,   :xpath, "div[@class='header']/span[@class='method_name']"
  element :path,          :xpath, "pre[@class='body']/div[@class='path']"
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
