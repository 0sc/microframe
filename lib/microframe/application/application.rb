require File.join(__dir__, "../", "routing", "router")

module Microframe
  class Application
    attr_reader :request, :routes
    def initialize
      @routes = Router.new
    end

    def call(env)
      @request = Rack::Request.new(env)
      verb = request.request_method
      path = request.path_info
      routes.request = request

      routes.handle_request(verb, path)
    end
  end
end
