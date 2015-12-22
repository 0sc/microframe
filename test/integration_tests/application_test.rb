require_relative "base"

class ApplicationTest < CapybaraTestCase
  def setup
    setup_app
  end

  def test_returns_404_if_route_is_not_found
    visit "/non_existent_route"
    assert page.has_content?("We are here")
    assert_equal 404, page.status_code
  end

  def test_returns_custom_404_if_view_is_not_found
    visit "/missing_view"
    assert page.title.include? "Not Found"
    within "ul" do
      assert page.has_content?("Couldn't find view")
    end
    assert_equal 404, page.status_code
  end

  def test_returns_custom_404_if_layout_is_not_found
    visit "/missing_layout"
    assert page.title.include? "Not Found"
    within "ul" do
      assert page.has_content?("Couldn't find layout")
    end
    assert_equal 404, page.status_code
  end

  def test_visit_items_with_wrong_params_redirect_to_home
    # visit "/lists/id/items/"
    # assert page.current_path, "/lists/id"
  end
end
