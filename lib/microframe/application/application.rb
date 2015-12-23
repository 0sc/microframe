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
      routes.request = request
      routes.handle_request
    end
  end
end
