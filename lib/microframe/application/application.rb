require File.join(__dir__, "../", "routing", "router")

module Microframe
  class Application
    attr_reader :request, :routes
    def initialize
      @routes = Router.new
      require File.join(__dir__, "..", "orm", "base")
    end

    def call(env)
      @request = Rack::Request.new(env)
      response = Rack::Response.new
      routes.request = request
      routes.response = response
      response = routes.handle_request
      response.finish
    end
  end
end
