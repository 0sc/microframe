require "test_helper"
require "router"
require "mapper"
require "mock_objects"

class RouterTest < Minitest::Test
  def setup
    @router = Microframe::Router.new
    @router.request = Sample.new
    @router.response = Sample.new
  end

  def test_initializes_empty_route_hash
    assert_empty @router.routes
    assert_kind_of Hash, @router.routes
  end

  def test_controller_setup_throws_error_args
    invalid_args_test(@router, :setup_controller)
  end

  def test_setup_http_verbs
    assert_respond_to @router, :get
    assert_respond_to @router, :post
    assert_respond_to @router, :patch
    assert_respond_to @router, :put
    assert_respond_to @router, :delete
  end

  def test_route_drawing
    assert_empty @router.routes
    @router.draw { get "/index", to: "controller#action" }
    refute_nil @router.routes
    assert_equal @router.routes["GET"],
                 "/index" => { controller: "controller", action: "action" }
  end

  def test_route_drawing_throws_args_error
    invalid_args_test(@router, :draw)
  end

  def test_create_routes_for_resources
    assert_empty @router.routes
    @router.resources("test")
    refute_empty @router.routes
    assert_equal @router.routes["GET"]["/test"],
                 controller: "test", action: "index"
    assert_equal @router.routes["GET"]["/test/new"],
                 controller: "test", action: "new"
    assert_equal @router.routes["GET"]["/test/:id"],
                 controller: "test", action: "show"
    assert_equal @router.routes["GET"]["/test/:id/edit"],
                 controller: "test", action: "edit"
    assert_equal @router.routes["POST"]["/test"],
                 controller: "test", action: "create"
    assert_equal @router.routes["PATCH"]["/test/:id"],
                 controller: "test", action: "update"
    assert_equal @router.routes["PUT"]["/test/:id"],
                 controller: "test", action: "update"
    assert_equal @router.routes["DELETE"]["/test/:id"],
                 controller: "test", action: "destroy"
  end

  def test_create_routes_for_resources_throws_args_error
    invalid_args_test(@router, :draw)
  end

  def test_get_handler_returns_path_handler_hash
    @router.resources("anything")
    assert_equal @router.send(:get_handler, "GET", "/anything"),
                 controller: "anything", action: "index"
    assert_equal @router.send(:get_handler, "GET", "/anything/new"),
                 controller: "anything", action: "new"
    assert_equal @router.send(:get_handler, "GET", "/anything/:id"),
                 controller: "anything", action: "show"
    assert_equal @router.send(:get_handler, "POST", "/anything"),
                 controller: "anything", action: "create"
    assert_equal @router.send(:get_handler, "PUT", "/anything/:id"),
                 controller: "anything", action: "update"
    assert_equal @router.send(:get_handler, "PATCH", "/anything/:id"),
                 controller: "anything", action: "update"
    assert_equal @router.send(:get_handler, "DELETE", "/anything/:id"),
                 controller: "anything", action: "destroy"
  end

  def test_get_handler_returns_nil_if_not_found
    assert_empty @router.routes
    @router.resources :anotherthing
    refute_empty @router.routes
    refute @router.send(:get_handler, "GET", "/something")
    assert_nil @router.send(:get_handler, "GET", "/something")
  end

  def test_get_handler_throws_args_error
    invalid_args_test(@router, :get_handler)
  end

  def test_set_route_stores_routes
    assert_empty @router.routes
    @router.send(:set_route, "GET", "/path", to: "controller#action")
    refute_empty @router.routes
    assert_equal @router.routes["GET"]["/path"],
                 controller: "controller", action: "action"
  end

  def test_set_route_throws_args_error
    invalid_args_test(@router, :set_route)
  end

  def test_setup_handler_process_handlers
    assert_equal @router.send(:setup_handler, to: "a#b"),
                 controller: "a", action: "b"
  end

  def test_setup_handler_throws_args_error
    invalid_args_test(@router, :setup_handler)
  end

  def test_mission_path_returns_404
    assert_kind_of Sample, @router.send(:missing_path)
  end
end
