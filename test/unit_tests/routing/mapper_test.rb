require "test_helper"
require "mapper"
require "utils"

class MapperTest < Minitest::Test
  include Utils
  def setup
    @mapper = Microframe::Mapper.new(SampleRoutes)
  end

  def test_mapper_start_returns_instance_of_mapper_class
    assert_instance_of Microframe::Mapper, Microframe::Mapper.start({})
  end

  def test_mapper_start_throws_args_error
    invalid_args_test(Microframe::Mapper, :start)
  end

  def test_map_returns_target_if_mapped
    assert_equal @mapper.map("GET", "/lists/new"), controller: "lists", action: "new"
    assert_equal @mapper.map("GET", "/lists/an_id"), controller: "lists", action: "show"
    assert_equal @mapper.map("PATCH", "/lists/an_id"), controller: "lists", action: "update"
  end

  def test_map_returns_nil_if_route_is_not_mapped
    refute_equal @mapper.map("GET", "/list/new"), controller: "lists", action: "new"
    assert_nil @mapper.map("GET", "/list/new")
    refute_equal @mapper.map("DELETE", "/lists/an_id"), controller: "lists", action: "show"
    assert_nil @mapper.map("DELETE", "/lists/an_id")
    refute_equal @mapper.map("POST", "/lists/an_id"), controller: "lists", action: "update"
    assert_nil @mapper.map("POST", "/lists/an_id")
  end

  def test_map_throws_args_error
    invalid_args_test(@mapper, :map )
  end

  def test_matches_components
    assert @mapper.match_components("item", "item")
    assert @mapper.match_components("path", "path")
  end

  def test_do_match_placeholders
    assert @mapper.match_components(":item", "something")
    assert @mapper.match_components(":path", "anotherthing")
  end

  def test_does_not_match_unequal_args
    refute @mapper.match_components("item", "something")
    refute @mapper.match_components(":path)", "anotherthing")
    refute @mapper.match_components(":path(", "anotherthing")
    refute @mapper.match_components(":path", nil)
    refute @mapper.match_components("path", ":anotherthing")
  end

  def test_matches_components_throws_args_error
    invalid_args_test(@mapper, :match_components )
  end

  def test_match_begin_of_optional_components
    assert_equal @mapper.match_begin_of_optional_components("path(", 0), ["path", 1, true]
    assert_equal @mapper.match_begin_of_optional_components("anotherpath(", 7), ["anotherpath", 8, true]
    assert_equal @mapper.match_begin_of_optional_components("yetanotherpath(", 10), ["yetanotherpath", 11, true]
  end

  def test_does_not_match_begin_of_option_components_if_not_match
    refute_equal @mapper.match_begin_of_optional_components("(path", 0), ["path", 1, true]
    assert_equal @mapper.match_begin_of_optional_components("(path", 0), ["(path", 0, nil]
    refute_equal @mapper.match_begin_of_optional_components("anotherpath", 7), ["anotherpath", 7, true]
    assert_equal @mapper.match_begin_of_optional_components("anotherpath", 7), ["anotherpath", 7, nil]
    refute_equal @mapper.match_begin_of_optional_components("yetanot(herpath", 10), ["yetanotherpath", 11, true]
    assert_equal @mapper.match_begin_of_optional_components("yetanot(herpath", 10), ["yetanot(herpath", 10, nil]
  end

  def test_match_begin_of_optional_components_throws_args_error
    invalid_args_test(@mapper, :match_begin_of_optional_components)
  end

  def test_match_end_of_optional_components
    assert_equal @mapper.match_end_of_optional_components("path)", 3), ["path", 2, true]
    assert_equal @mapper.match_end_of_optional_components("anotherpath)", 7), ["anotherpath", 6, true]
    assert_equal @mapper.match_end_of_optional_components("yetanotherpath)", 10), ["yetanotherpath", 9, true]
  end

  def test_does_not_match_end_of_option_components_if_not_match
    refute_equal @mapper.match_end_of_optional_components(")path", 3), ["path", 3, true]
    assert_equal @mapper.match_end_of_optional_components(")path", 0), [")path", 0, nil]
    refute_equal @mapper.match_end_of_optional_components("anotherpath", 7), ["anotherpath", 6, true]
    assert_equal @mapper.match_end_of_optional_components("anotherpath", 7), ["anotherpath", 7, nil]
    refute_equal @mapper.match_end_of_optional_components("yetanot)herpath", 10), ["yetanotherpath", 9, true]
    assert_equal @mapper.match_end_of_optional_components("yetanot)herpath", 10), ["yetanot)herpath", 10, nil]
  end

  def test_match_end_of_optional_components_throws_args_error
    invalid_args_test(@mapper, :match_end_of_optional_components)
  end

  def test_match_optional_components
    assert_equal @mapper.match_optional_components("val", 1, 5), [true, 4, true]
    assert_equal @mapper.match_optional_components("anotherval", 5, 2), [true, 1, true]
    assert_equal @mapper.match_optional_components("yetanotherval", 6, 9), [true, 8, true]
  end

  def test_does_not_match_option_components_if_not_match
    refute_equal @mapper.match_optional_components("val", 0, 5), [true, 4, true]
    assert_equal @mapper.match_optional_components("val", 0, 5), ["val", 5, "val"]
    refute_equal @mapper.match_optional_components("anotherval", 0, 2), [true, 1, true]
    assert_equal @mapper.match_optional_components("anotherval", 0, 2), ["anotherval", 2, "anotherval"]
    refute_equal @mapper.match_optional_components("yetanotherval", 0, 9), [true, 8, true]
    assert_equal @mapper.match_optional_components("yetanotherval", 0, 9), ["yetanotherval", 9, "yetanotherval"]
  end

  def test_match_optional_components_throws_args_error
    invalid_args_test(@mapper, :match_optional_components)
  end

  def test_match_this_returns_false_path_greater_than_routes
    refute @mapper.match_this("this/is/route", "this/is/extra/route")
    refute @mapper.match_this("/route", "/extra/route")
    refute @mapper.match_this("this/is/", "this/is/extra/route")
  end

  def test_match_this_returns_true_if_matched
    assert @mapper.match_this("this/route", "this/route")
    assert @mapper.match_this("this/:route", "this/route")
    # assert @mapper.match_this("this(/route)", "this/")
    assert @mapper.match_this("this(/route)", "this/route")
  end

  def test_match_this_returns_false_if_not_matched
    refute @mapper.match_this("this/route", "that/route")
    refute @mapper.match_this("that/:route", "this/route")
    refute @mapper.match_this("this(/route)", "this/")
    refute @mapper.match_this("this(/route)", "this/route/extra")
  end

  def test_match_this_throws_args_error
    invalid_args_test(@mapper, :match_this)
  end
end
