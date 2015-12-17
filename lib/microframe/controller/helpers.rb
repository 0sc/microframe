require File.join(__dir__, "form_helper")

module Microframe
  module Helpers
    def link_to(link, target, options = {})
      if options[:method]
        target = target.is_a?(String) ? target : "/#{target.class.to_s.downcase}s/#{target.id}"

        "<form action='#{target}' method='post'>
          <input type='hidden' name='_method' value='#{options[:method]}'/>
          <input type='submit' value='#{link}' />
        </form>"
      else
        data_options = ""
        options[:data].each { |key, val| data_options << "data-#{key}='#{val}'"} if options[:data]
        "<a href='#{target}' #{data_options} >#{link}</a>"
      end
    end

    def form_for(target, link=nil, &block)
      yield(FormHelper.new(target, link))
    end


  end
end
