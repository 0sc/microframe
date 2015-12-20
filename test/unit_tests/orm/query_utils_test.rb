require "test_helper"
require "base"

class Sample < Microframe::ORM::Base
end

class QueryUtilsTest < Minitest::Test
  def setup
    @base = Sample.new
  end

  def test_process_query_runs_execute
    @base.stub(:build_query, "")do
      @base.stub(:execute, "executed")do
        assert_equal "executed", @base.process_query("query")
      end
    end
  end

  def test_process_query_throws_args_error
    invalid_args_test(@base, :process_query)
  end

  def test_process_select
    queryhash = { "SELECT" => ["id", "name", "email"] }
    assert_equal "SELECT id, name, email", @base.process_select(queryhash)
  end

  def test_process_select_defaults_to_wildcard
    assert_equal "SELECT *", @base.process_select(Hash.new)
  end

  def test_process_select_throws_args_error
    invalid_args_test(@base, :process_select)
  end

  def test_process_from
    queryhash = { "FROM" => "mytable"}
    assert_equal "FROM mytable", @base.process_from(queryhash)
  end

  def test_process_from_sets_default_table_name
    assert_equal "FROM samples", @base.process_from(Hash.new)
  end

  def test_process_from_throws_args_error
    invalid_args_test(@base, :process_from)
  end

  def test_process_where
    queryhash = { "WHERE" => ["id = 4", "name = 'myname'", "email = 'mail@mail.com'"] }
    assert_equal "WHERE id = 4 AND name = 'myname' AND email = 'mail@mail.com'", @base.process_where(queryhash)
  end

  def test_process_empty_string_if_empty
    assert_empty @base.process_where(Hash.new)
  end

  def test_process_where_throws_args_error
    invalid_args_test(@base, :process_where)
  end

  def test_process_generic
    queryhash = {
      "LIMIT" => 8,
      "ORDER BY" => "id DESC"
    }
    assert_equal "ORDER BY id DESC", @base.process_order(queryhash)
    assert_equal "LIMIT 8", @base.process_limit(queryhash)
  end

  def test_process_generic_defaults_to_empty
    queryhash = {}
    refute_equal "ORDER BY id DESC", @base.process_order(queryhash)
    refute_equal "LIMIT 8", @base.process_limit(queryhash)
    assert_empty @base.process_order(queryhash)
    assert_empty @base.process_limit(queryhash)
  end

  def test_process_generic_throws_args_error
    invalid_args_test(@base, :process_generic)
    invalid_args_test(@base, :process_order)
    invalid_args_test(@base, :process_limit)
  end

  def test_query_processes
    assert_equal 5, @base.query_processes.size
    assert_equal [:process_select, :process_from, :process_where, :process_order, :process_limit], @base.query_processes
  end

  def test_build_query
    sample1 = {
      "SELECT" => ["name", "email"],
      "FROM" => "tablename",
      "ORDER BY" => "id DESC"
    }
    query1 = "SELECT name, email FROM tablename  ORDER BY id DESC"
    sample2 = {
      "FROM" => "tablename",
      "WHERE" => ["name = 'me'", "email = 'mail@mail.com'"],
      "LIMIT" => "100"

    }
    query2 = "SELECT * FROM tablename WHERE name = 'me' AND email = 'mail@mail.com'  LIMIT 100"
    sample3 = {
      "SELECT" => ["name"],
      "WHERE" => ["name = 'me'", "email = 'mail@mail.com'"],
      "LIMIT" => "100",
      "ORDER BY" => "id DESC"
    }
    query3 = "SELECT name FROM samples WHERE name = 'me' AND email = 'mail@mail.com' ORDER BY id DESC LIMIT 100"

    [[sample1, query1],[sample2, query2], [sample3, query3]].each do |pkg|
      assert_equal @base.build_query(pkg.first), pkg.last
    end
  end
end
