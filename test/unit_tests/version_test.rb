require "microframe/version"
require 'test_helper'

class VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Microframe::VERSION
  end
end
