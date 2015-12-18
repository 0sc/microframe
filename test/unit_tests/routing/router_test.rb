require "test_helper"
require "router"
require "mapper"
require "utils"


class RouterTest < Minitest::Test
  include Utils
  def setup
    @router = Microframe::Router.new
    @router.request = Object.new
    @router.request.instance_eval { def params; end; def view_rendered; end; def render_view; end; def path_info; end; def host; end }
  end

  def test_initializes_empty_route_hash
    assert_empty @router.route
    assert_kind_of Hash, @router.route
  end

  def test_valid_handling_of_request
    response = "This is my view response"
    @router.stub(:route, SampleRoutes)do
        @router.request.stub(:params, {}) do
          @router.stub(:setup_controller, response)do
            @router.stub(:object, @router.request)do
              @router.object.stub(:view_rendered, true) do
                assert_equal response, @router.handle_request("GET", "/lists/new")
                assert_equal response, @router.handle_request("PATCH", "/lists/9")
                assert_equal response, @router.handle_request("PATCH", "/lists/random_something")
              end
            end
          end
      end
    end
  end

  def test_handling_of_request_throws_error_with_invalid_args
    invalid_args_test(@router, :handle_request)
  end

  def test_return_missing_path_if_handler_is_not_found
    @router.stub(:route, SampleRoutes)do
      @router.stub(:missing_path, [404, {},["Some message"]])do
        assert_includes @router.handle_request("GET", "/anyundefinedpath"), 404
        assert_includes @router.handle_request("POST", "/lists/random_something"), 404
      end
    end
  end

  def test_render_default_view_if_no_explicit_render
    response = "This is my custom view"
    default_response = "This is my default view"
    @router.stub(:route, SampleRoutes)do
      @router.request.stub(:params, {}) do
        @router.stub(:setup_controller, "This is response")do
          @router.stub(:object, @router.request)do
            @router.object.stub(:view_rendered, false) do
              @router.object.stub(:render_view, default_response) do
                refute_equal response, @router.handle_request("GET", "/lists/new")
                assert_equal default_response, @router.handle_request("GET", "/lists/new")
                refute_equal response, @router.handle_request("GET", "/lists/new")
                assert_equal default_response, @router.handle_request("GET", "/lists/new")
                refute_equal response, @router.handle_request("PATCH", "/lists/9")
                assert_equal default_response, @router.handle_request("PATCH", "/lists/9")
                refute_equal response, @router.handle_request("PATCH", "/lists/random_something")
                assert_equal default_response, @router.handle_request("PATCH", "/lists/random_something")
              end
            end
          end
        end
      end
    end
  end

  def test_controller_setup

  end

  def test_controller_setup_throws_error_args
    invalid_args_test(@router, :setup_controller)
  end

  def test_setup_controller_throws_error_if_controller_not_found

  end

  def test_setup_controller_throws_error_if_controller_action_not_found

  end

  def test_setup_http_verbs
    assert_respond_to @router, :get
    assert_respond_to @router, :post
    assert_respond_to @router, :patch
    assert_respond_to @router, :put
    assert_respond_to @router, :delete
  end

  def test_route_drawing
    assert_empty @router.route
    @router.draw{ get "/index", to: "controller#action" }
    refute_nil @router.route
    assert_equal @router.route["GET"], "/index" => {controller: "controller", action: "action"}
  end

  def test_route_drawing_throws_args_error
    invalid_args_test(@router, :draw)
  end

  def test_create_routes_for_resources
    assert_empty @router.route
    @router.resources("test")
    refute_empty @router.route
    assert_equal @router.route["GET"]["/test"], controller: "test", action: "index"
    assert_equal @router.route["GET"]["/test/new"], controller: "test", action: "new"
    assert_equal @router.route["GET"]["/test/:id"], controller: "test", action: "show"
    assert_equal @router.route["GET"]["/test/:id/edit"], controller: "test", action: "edit"
    assert_equal @router.route["POST"]["/test"], controller: "test", action: "create"
    assert_equal @router.route["PATCH"]["/test/:id"], controller: "test", action: "update"
    assert_equal @router.route["PUT"]["/test/:id"], controller: "test", action: "update"
    assert_equal @router.route["DELETE"]["/test/:id"], controller: "test", action: "destroy"
  end

  def test_create_routes_for_resources_throws_args_error
    invalid_args_test(@router, :draw)
  end

  def test_get_handler_returns_path_handler_hash
    @router.resources("anything")
    assert_equal @router.send(:get_handler, "GET", "/anything"), controller: "anything", action: "index"
    assert_equal @router.send(:get_handler, "GET", "/anything/new"), controller: "anything", action: "new"
    assert_equal @router.send(:get_handler, "GET", "/anything/:id"), controller: "anything", action: "show"
    assert_equal @router.send(:get_handler, "POST", "/anything"), controller: "anything", action: "create"
    assert_equal @router.send(:get_handler, "PUT", "/anything/:id"), controller: "anything", action: "update"
    assert_equal @router.send(:get_handler, "PATCH", "/anything/:id"), controller: "anything", action: "update"
    assert_equal @router.send(:get_handler, "DELETE", "/anything/:id"), controller: "anything", action: "destroy"

  end

  def test_get_handler_returns_nil_if_not_found
    assert_empty @router.route
    @router.resources :anotherthing
    refute_empty @router.route
    refute @router.send(:get_handler, "GET", "/something")
    assert_nil @router.send(:get_handler, "GET", "/something")
  end

  def test_get_handler_throws_args_error
    invalid_args_test(@router, :get_handler)
  end

  def test_set_route_stores_routes
    assert_empty @router.route
    @router.send(:set_route, "GET", "/path", to: "controller#action")
    refute_empty @router.route
    assert_equal @router.route["GET"]["/path"], controller: "controller", action: "action"
  end

  def test_set_route_throws_args_error
    invalid_args_test(@router, :set_route)
  end

  def test_setup_handler_process_handlers
    assert_equal @router.send(:setup_handler, to: "a#b"), controller: "a", action: "b"
  end

  def test_setup_handler_throws_args_error
    invalid_args_test(@router, :setup_handler)
  end

  def test_get_handler_file_requires_the_right_controller_file

  end

  def test_get_handler_file_throws_error_if_controller_file_not_found

  end

  def test_get_handler_file_throws_args_error

  end

  def test_mission_path_returns_404
    assert_kind_of Array, @router.send(:missing_path)
    assert_includes @router.send(:missing_path), 404
  end
end
