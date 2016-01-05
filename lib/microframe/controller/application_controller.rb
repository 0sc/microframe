require File.join(__dir__, "helpers")
require File.join(__dir__, "view_object")
require File.join(__dir__, "session")

module Microframe
   class ApplicationController
     include Helpers
     include Session
     attr_reader :request, :params, :view_rendered, :errors, :child, :action, :view_vars, :response
     attr_accessor :session

     def initialize(request, child, action, response)
       @request = request
       @child = child
       @action = action
       @params = request.params
       @response = response
       @session = request.cookies
     end

     def default_render_option
       { view: action, layout: "application" }
     end

     def redirect_to(location)
       @view_rendered = true
       response.redirect(location)
       cleanup!
       response
     end

     def render(options = {})
      @view_rendered = true
      view = get_view(options[:view])
      layout = get_layout(options[:layout])
      obj = set_up_view_object
      response.status = 200

      if(render_error?(view, layout))
        tilt = Tilt.new(File.join(APP_PATH, "public", "404.html.erb"))
        view = tilt.render(obj, errors: @errors)
        response.status = 404
        response.write(view)
      else
        template = Tilt::ERBTemplate.new(layout)
        tilt = Tilt::ERBTemplate.new(view)
        view = template.render(obj){ tilt.render(obj)}
        response.write(view)
      end
      cleanup!
      response
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

     def cleanup!
       save_session
       save_flash
       save_notice
       save_alert
     end
   end
end
