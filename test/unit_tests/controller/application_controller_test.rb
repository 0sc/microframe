require "test_helper"
require "application_controller"

class ApplicationControllerTest < Minitest::Test
  def setup
    @app = Microframe::ApplicationController.new(
      Sample.new, "controller", "action", Sample.new)
  end

  def test_default_rendered_view_option
    assert_equal @app.default_render_option,
                 view: "action", layout: "application"
  end

  def test_redirect_to
    assert_instance_of Sample, @app.redirect_to("target")
  end

  def test_render_view
    @app.stub(:render, "will return render") do
      assert_equal "will return render", @app.render_view
    end
  end

  def test_render_error_returns_view_not_found_error
    assert @app.render_error?("invalid view", __FILE__)
    assert_includes @app.errors, "Couldn't find view: invalid view"
    assert_equal 1, @app.errors.size
  end

  def test_render_error_returns_layout_not_found_error
    assert @app.render_error?(__FILE__, "invalid layout")
    assert_includes @app.errors, "Couldn't find layout: invalid layout"
    assert_equal 1, @app.errors.size
  end

  def test_render_error_returns_layout_view_error
    assert @app.render_error?("invalid view", "invalid layout")
    assert_includes @app.errors, "Couldn't find view: invalid view"
    assert_includes @app.errors, "Couldn't find layout: invalid layout"
    assert_equal 2, @app.errors.size
  end

  def test_get_layout_returns_given_file
    assert_equal @app.get_layout(__FILE__),
                 File.join(APP_PATH, "app", "views",
                           "layouts", "#{__FILE__}.html.erb")
  end

  def test_get_layout_returns_default
    assert_equal @app.get_layout,
                 File.join(APP_PATH, "app", "views",
                           "layouts", "application.html.erb")
  end

  def test_set_instance_variables_for_views
    @app.instance_eval { @an_instance_var = "something" }
    refute_empty @app.set_instance_variables_for_views
    assert_equal @app.set_instance_variables_for_views,
                 "an_instance_var" => "something", "params" => nil
  end

  def test_set_instance_variables_for_views_avoids_protect_vars
    @app.instance_eval { @an_instance_var = "something" }
    refute_empty @app.set_instance_variables_for_views
    assert_equal @app.set_instance_variables_for_views,
                 "params" => nil, "an_instance_var" => "something"
    refute_includes @app.set_instance_variables_for_views,
                    "session" => {},
                    "requests" => Sample.new, "response" => Sample.new
  end

  def test_view_object
    @app.instance_eval { @an_instance_var = "something" }
    obj = @app.set_up_view_object
    refute_empty obj.instance_variables
    assert_includes obj.instance_variables, :@an_instance_var
  end
end
