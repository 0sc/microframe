module Microframe
  class FormHelper
    attr_reader :target, :target_id, :form_started,:target_name
    attr_accessor :link

    def initialize (target, link)
      @target = target
      @target_name = target.class.to_s.downcase
      @link = link
      @form_started = false
    end

    def start_form
      @form_started = true
      @target_id = target.id ? target.id : nil
      link ||= "/#{target_name}s/#{target_id || ""}"
      "<form action='#{link}' method='post'>"
    end

    def label(name)
      gatekeeper "<label>#{name}</label>"
    end

    def text_area(name)
      gatekeeper "<textarea name = '#{target_name}[name]'>#{target.send(name)}</textfield>"
    end

    def text_field(name)
      gatekeeper "<input type = 'text' name = '#{target_name}[name]' value = '#{target.send(name)}'/>"
    end

    def submit
      output = ""
      output += "<input type='hidden' name='_method' value='put'>" if target_id
      output += "<input type='submit' value = 'save' />"
      output += "</form>"
      gatekeeper output
    end

    def checkbox
    end

    def gatekeeper(output)
      form_started ? output : start_form + output
    end
  end
end
