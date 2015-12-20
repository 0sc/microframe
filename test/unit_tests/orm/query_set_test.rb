require "test_helper"
require "base"

class QuerysetTest < Minitest::Test
  def setup
    @util = Microframe::ORM::Queryset.new(Microframe::ORM::Base)
  end

  def test_where_method
    assert_equal @util.where(name: "myname", id: "myid"), @util
    assert_equal @util.queryset["WHERE"], ["name = 'myname' AND id = 'myid'"]
  end

  def test_all_method_with_no_args
    @util.stub(:fetch, "fetching")do
      assert_equal "fetching", @util.all
      assert_equal @util.queryset["SELECT"], ["*"]
    end
  end

  def test_all_method_with_args
    @util.stub(:fetch, "fetching")do
      assert_equal "fetching", @util.all("name")
      assert_equal @util.queryset["SELECT"], ["name"]
    end
  end

  def test_find_by_method
    assert_equal @util.find_by(name: "myname"), @util
    assert_equal @util.queryset["WHERE"], ["name = 'myname'"]
    assert_equal @util.find_by(email: "email@email.com"), @util
    assert_equal @util.queryset["WHERE"], ["name = 'myname'", "email = 'email@email.com'"]
  end

  def test_find_method
    assert_equal @util.find(10), @util
    assert_equal @util.queryset["WHERE"], ["id = '10'"]
    assert_equal @util.find(70), @util
    assert_equal @util.queryset["WHERE"], ["id = '10'", "id = '70'"]
  end

  def test_all_method_with_args
    assert_equal @util.select("email"), @util
    assert_equal @util.queryset["SELECT"], ["email"]
  end

  def test_limit
    assert_equal @util.limit(10), @util
    assert_equal @util.queryset["LIMIT"], 10
    assert_equal @util.limit(1), @util
    assert_equal @util.queryset["LIMIT"], 1
  end

  def test_order
    assert_equal @util.order("email DESC"), @util
    assert_equal @util.queryset["ORDER BY"], "email DESC"
    assert_equal @util.order("name ASC"), @util
    assert_equal @util.queryset["ORDER BY"], "name ASC"
  end

  def test_add_query
    assert_empty @util.queryset
    assert_equal @util.add_query("WHERE", "id = '12'"), @util
    assert_equal @util.queryset, "WHERE" => ["id = '12'"]
    assert_equal @util.add_query("SELECT", "name"), @util
    assert_equal @util.queryset, "WHERE" => ["id = '12'"], "SELECT" => ["name"]
    assert_equal @util.add_query("WHERE", "name = 'name'"), @util
    assert_equal @util.queryset, "WHERE" => ["id = '12'", "name = 'name'"], "SELECT" => ["name"]
    assert_equal @util.add_query("SELECT", "id"), @util
    assert_equal @util.queryset, "WHERE" => ["id = '12'", "name = 'name'"], "SELECT" => ["name", "id"]
  end

  def test_fetch_query
    @util.stub(:process_query, [])do
      @util.stub(:parse_result_to_objects, "parsed")do
        assert_equal "parsed", @util.fetch
      end
    end
  end

  def test_load
    @util.stub(:fetch, ["a", "b"]) do
      assert_equal @util.load, "a"
    end
  end
end
