require "test_helper"
require "base"
require "mock_objects"

class BaseTest < Minitest::Test
  def setup
    @base = Sample.new
  end

  def test_table_name
    assert_equal "samples", @base.table_name
  end

  def test_it_includes_instance_queries
    [:save, :update, :destroy].each { |q| assert_respond_to @base, q}
  end
end
