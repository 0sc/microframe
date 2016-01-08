require "test_helper"
require "mock_objects"

class HelpersTest < Minitest::Test
  def setup
    @help = Microframe::ApplicationController.new(Sample.new, "controller", "action", Sample.new)
  end

  def test_link_to_with_delete_option
    assert_equal @help.link_to("Destroy", "delete_link", method: :delete), "<form action='delete_link' method='post'><input type='hidden' name='_method' value='delete'/><input type='submit' value='Destroy' /></form>"

    assert_equal @help.link_to("Destroy", Sample.new, method: :delete), "<form action='/samples/123' method='post'><input type='hidden' name='_method' value='delete'/><input type='submit' value='Destroy' /></form>"
  end

  def test_link_to_without_delete_option
    assert_equal @help.link_to("root", "root_link"), "<a href = 'root_link'  >root</a>"

    assert_equal @help.link_to("root", "root_link", "data-confirm" => "Are you sure"), "<a href = 'root_link' data-confirm='Are you sure' >root</a>"
  end

  def test_form_for
    assert_equal @help.form_for(Sample.new, "link_to_sample") { |f| f.label :Name}, "<form action='link_to_sample' method='post'><label >Name</label>"

    assert_equal @help.form_for(Sample.new, "link_to_sample") { |f| f.text_field :id}, "<form action='link_to_sample' method='post'><input type = 'text' name = 'sample[id]' value = '123' />"
  end

  # def test_javascript_tag
  #   assert_equal "#{APP_PATH}/app/assets/javascripts/script.js", @help.javascript_tag("script")
  # end
  #
  # def test_image_tag
  #   assert_equal "#{APP_PATH}/app/assets/images/image.png", @help.image_tag("image")
  #   assert_equal "#{APP_PATH}/app/assets/images/image.jpg", @help.image_tag("image", "jpg")
  # end
  #
  # def test_stylesheet_tag
  #   assert_equal "#{APP_PATH}/app/assets/stylesheets/style.css", @help.stylesheet_tag("style")
  #   assert_equal "#{APP_PATH}/app/assets/stylesheets/style.scss", @help.stylesheet_tag("style", "scss")
  # end
end
