require "test_helper"
require "base"

class Sample < Microframe::ORM::Base
end

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

  def test_update
    @base.stub(:save, "saved")do
      assert_nil @base.save_queryset
      assert_equal "saved", @base.update(name: "newname")
      refute_nil @base.save_queryset
      assert_equal @base.save_queryset, name: "newname"
    end
  end
end
