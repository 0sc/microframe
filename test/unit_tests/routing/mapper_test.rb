require "test_helper"
require "mapper"

class MapperTest < Minitest::Test
  def setup
    mapper = Mapper.new({})
  end

  def test_mapper_start_returns_instance_of_mapper_class

  end

  def test_mapper_start_throws_args_error

  end

  def test_map_returns_target_if_mapped

  end

  def test_map_returns_nil_if_route_is_not_mapped

  end

  def test_map_throws_args_error

  end

  def test_matches_components

  end

  def test_do_match_placeholders

  end

  def test_does_not_match_unequal_args

  end

  def test_matches_components_throws_args_error

  end

  def test_match_begin_of_optional_components

  end

  def test_does_not_match_begin_of_option_components_if_not_match

  end

  def test_match_begin_of_optional_components_throws_args_error

  end

  def test_match_end_of_optional_components

  end

  def test_does_not_match_end_of_option_components_if_not_match

  end

  def test_match_end_of_optional_components_throws_args_error

  end

  def test_match_optional_components

  end

  def test_does_not_match_option_components_if_not_match

  end

  def test_match_optional_components_throws_args_error

  end

  def test_match_this_returns_false_path_greater_than_routes

  end

  def test_match_this_returns_true_if_matched

  end

  def test_match_this_returns_false_if_not_matched

  end

  def test_match_this_throws_args_error

  end
end
