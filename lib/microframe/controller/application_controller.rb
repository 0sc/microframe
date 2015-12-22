require File.join(__dir__, "helpers")
require File.join(__dir__, "view_object")

module Microframe
   class ApplicationController
     include Helpers
     attr_reader :request, :params, :view_rendered, :errors, :child, :action, :view_vars

     def initialize(request, child, action)
       @request = request
       @child = child
       @action = action
       @params = request.params
     end

     def default_render_option
       { view: action, layout: "application" }
     end

     def redirect_to(location)
       @view_rendered = true
       [302, {"Location" => location}, []]
     end

     def render(options = {})
      @view_rendered = true
      view = get_view(options[:view])
      layout = get_layout(options[:layout])
      obj = set_up_view_object
      status = 200

      if(render_error?(view, layout))
        response = Tilt.new(File.join(APP_PATH, "public", "404.html.erb"))
        status = 404
        response = response.render(obj, errors: @errors)
      else
        template = Tilt::ERBTemplate.new(layout)
        view = Tilt::ERBTemplate.new(view)
        response = template.render(obj){ view.render(obj)}
      end

      [status, {}, [response]]
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

     def get_view(view = nil)
       view ||= default_render_option[:view]
       file = File.join(APP_PATH, "app", "views", child, "#{view}.html.erb")
       unless File.file? file
        file = File.join(APP_PATH, "app", "views", "#{view}.html.erb")
       end
       file
     end

     def get_layout(layout = nil)
       layout ||= default_render_option[:layout]
       File.join(APP_PATH, "app", "views", "layouts", layout + ".html.erb")
     end

     def render_partial(partial)
       partial = partial.split("/")
       partial[-1] = "_#{partial[-1]}"
       partial = Tilt::ERBTemplate.new(get_view(partial.join("/")))
       partial.render(self)
     end

     def set_instance_variables_for_views
       hash = {}
       vars = instance_variables
       vars -= protected_instance_variables_for_views
       vars.each { |var| hash[var[1..-1]] = instance_variable_get(var)}
       hash
     end

     def protected_instance_variables_for_views
       [:@request, :@action, :@view_rendered, :@child]
     end

     def set_up_view_object
       obj = ViewObject.new(self)
       obj.instance_exec(set_instance_variables_for_views) do |inst_vars|
         inst_vars.each{|key, value| instance_variable_set("@#{key}", value) }
       end
       obj
     end
   end
end
