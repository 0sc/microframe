require File.join(__dir__, "form_helper")

module Microframe
  module Helpers
    def link_to(link, target, options = {})
      xtras = []
      if options[:method]
        target = target.is_a?(String) ? target : "/#{target.class.to_s.downcase}s/#{target.id}"
        options.each { |key, val| xtras << "#{key}='#{val}'" unless key == :method }
        "<form action='#{target}' method='post'><input type='hidden' name='_method' value='#{options[:method]}'/><input type='submit' value='#{link}' #{xtras.join(" ")}/></form>"
      else
        options.each { |key, val| xtras << "#{key}='#{val}'"}
        "<a href = '#{target}' #{xtras.join(" ")} >#{link}</a>"
      end
    end

    def form_for(target, link=nil, &block)
      yield(FormHelper.new(target, link))
    end

    def image_tag(image, options={})
      xtras = []
      options.each {|key, val| xtras << "#{key} = '#{val}'"}
      img = File.join("images", image)
      "<img src = '/#{img}' #{xtras.join(' ')}/>"
    end

    def javascript_tag(js)
      script = File.join("javascripts", js)
      "<script type = 'text/javascript' src = '/#{script}'></script>"
    end

    def stylesheet_tag(style)
      stylesheet = File.join("stylesheets", style)
      "<link type = 'text/css' rel = 'stylesheet' href = '/#{stylesheet}'>"
    end
  end
end
