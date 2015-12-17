require File.join(__dir__, "helpers")

module Microframe
   class ApplicationController
     include Helpers
     attr_reader :request, :params, :view_rendered, :errors, :child, :action, :view_vars
     attr_accessor :notice

     def initialize(request, child, action)
       @request = request
       @child = child
       @action = action
       @params = request.params
     end

     def default_render_option
       { view: action, layout: "application" }
     end

     def render(options = {})
      @view_rendered = true
      view = get_view(options[:view])
      layout = get_layout(options[:layout])

      if(render_error?(view, layout))
        response = Tilt.new(File.join(".", "public", "404.html.erb"))
        response = response.render(Object.new, errors: @errors)
      else
        template = Tilt::ERBTemplate.new(layout)
        view = Tilt::ERBTemplate.new(view)
        @view_vars = set_instance_variables_for_views
        response = template.render(self, view_vars){ view.render(self, view_vars)}
      end

      [200, {}, [response]]
     end

     def render_view
       render default_render_option
     end

     def render_error?(view, layout)
       @errors = []
       @errors << "Couldn't find view: #{view}" unless File.file?view
       @errors << "Couldn't find layout: #{layout}" unless File.file?layout
       @errors.size > 0
     end

     def get_view(view)
       view ||= default_render_option[:view]
       file = File.join(".", "app", "views", child, "#{view}.html.erb")
       unless File.file? file
        file = File.join(".", "app", "views", "#{view}.html.erb")
       end
       file
     end

     def get_layout(layout)
       layout ||= default_render_option[:layout]
       File.join(".", "app", "views", "layouts", layout + ".html.erb")
     end

     def render_partial(partial)
       partial = partial.split("/")
       partial[-1] = "_#{partial[-1]}"
       partial = Tilt::ERBTemplate.new(get_view(partial.join("/")))
       partial.render(self, view_vars)
     end

     def set_instance_variables_for_views
       hash = {}
       vars = instance_variables
       vars -= protected_instance_variables_for_views
       vars.each { |var| hash[var[1..-1]] = instance_variable_get(var)}
       hash
     end

     def protected_instance_variables_for_views
       [@request]
     end
   end
end
