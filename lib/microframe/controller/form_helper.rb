module Microframe
  class FormHelper
    attr_reader :target, :target_id, :form_started,:target_name

    def initialize (target, target_link)
      @target = target
      @target_name = target.class.to_s.downcase
      @link = target_link
      @form_started = false
    end

    def start_form
      @form_started = true
      @target_id = target.id ? target.id : nil
      @link ||= "/#{target_name}s/#{target_id || ""}"
      "<form action='#{@link}' method='post'>"
    end

    def label(name, options = {})
      gatekeeper "<label #{parse_options(options)}>#{name}</label>"
    end

    def text_area(name, options = {})
      gatekeeper "<textarea name = '#{target_name}[#{name}]' #{parse_options(options)}>#{target.send(name)}</textarea>"
    end

    def text_field(name, options = {})
      gatekeeper "<input type = 'text' name = '#{target_name}[#{name}]' value = '#{target.send(name)}' #{parse_options(options)}/>"
    end

    def submit(options = {})
      output = ""
      output += "<input type = 'hidden' name = '_method' value = 'put'/>" if target_id
      output += "<input type = 'submit' value = 'save' #{parse_options(options)}/>"
      output += "</form>"
      gatekeeper output
    end

    def check_box(name, options = {})
      val = target.send(name)
      gatekeeper "<input type = 'checkbox' name = '#{target_name}[#{name}]' checked = '#{val}' #{parse_options(options)} value = 'true'/>"
    end

    def hidden(val)
      name = val.class.to_s.downcase
      val = val.id
      gatekeeper "<input type = 'hidden' name = '#{name}_id' value = '#{val}'/>"
    end

    def gatekeeper(output)
      form_started ? output : start_form + output
    end

    def parse_options(options)
      xtras = []
      options.each { |key, val| xtras << "#{key} = '#{val}'"}
      xtras.join(" ")
    end
  end
end
