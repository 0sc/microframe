require "test_helper"
require "class_queries"

class ClassQueriesTest < Minitest::Test
  def setup
    @queries = Microframe::ORM::Base
  end

  def test_property_process_table_queries
    assert_empty @queries.get_create_table_query
    @queries.property(:id, type: :integer, primary_key: true)
    assert @queries.get_create_table_query
    assert_equal 1, @queries.get_create_table_query.size
    assert_equal @queries.get_create_table_query[0],
                 "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL"

    @queries.property(:description, type: :text)
    assert_equal 2, @queries.get_create_table_query.size
    assert_equal @queries.get_create_table_query[1],
                 "description TEXT NOT NULL "

    @queries.property(:done, type: :boolean)
    assert_equal 3, @queries.get_create_table_query.size
    assert_equal @queries.get_create_table_query[2], "done BOOLEAN NOT NULL "
  end

  def test_property_throws_args_error
    invalid_args_test(@queries, :property)
  end

  def test_responds_to_class_queries
    mtds = [
      :all, :find, :find_by, :where, :select, :count,
      :first, :last, :limit, :order, :destroy, :destroy_all
    ]
    mtds.each { |mtd| assert_respond_to @queries, mtd }
  end
end
