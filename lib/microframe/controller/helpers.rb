require File.join(__dir__, "form_helper")

module Microframe
  module Helpers
    def link_to(link, target, options = {})
      if options[:method]
        target = target.is_a?(String) ? target : "/#{target.class.to_s.downcase}s/#{target.id}"

        "<form action='#{target}' method='post'><input type='hidden' name='_method' value='#{options[:method]}'/><input type='submit' value='#{link}' /></form>"
      else
        data_options = ""
        options[:data].each { |key, val| data_options << "data-#{key}='#{val}'"} if options[:data]
        "<a href='#{target}' #{data_options} >#{link}</a>"
      end
    end

    def form_for(target, link=nil, &block)
      yield(FormHelper.new(target, link))
    end

    def image_tag(image, ext = "png")
      File.join(".", "app", "assets", "images", "#{image}.#{ext}")
    end

    def javascript_tag(js)
      File.join(".", "app", "assets", "javascripts", "#{js}.js")
    end

    def stylesheet_tag(style, ext = "css")
      File.join(".", "app", "assets", "stylesheets", "#{style}.#{ext}")
    end
  end
end
