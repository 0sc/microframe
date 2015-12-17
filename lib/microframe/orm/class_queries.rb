require File.join(__dir__,"query_utils")
require File.join(__dir__,"instance_queries")
require File.join(__dir__,"relationships")

module Microframe
  module ORM
    class Base
      @@queryset = {}
      class << self
        include QueryUtils
        include Relationships

        def inherited(base)
          base.include InstanceQueries
          base.include QueryUtils
        end

        def property(col_name, options = {})
          @@create_table_query ||= []
          options[:type] = options[:type].to_s.upcase
          options[:nullable] = options[:nullable] ? "NULL" : "NOT NULL"
          options[:primary_key] = options[:primary_key] ? "PRIMARY KEY AUTOINCREMENT" : ""
          @@create_table_query << col_name.to_s + " " + options.values.join(" ")
        end

        def create_table
          query = "CREATE TABLE IF NOT EXISTS #{table_name} (#{@@create_table_query.join(", ")})"
          if Connection.execute(query)
            @@create_table_query = nil
            define_attributes
          end
        end

        def define_attributes
          Connection.retrieve_columns(table_name).each do |column|
            define_method("#{column}=") do |val|
              instance_var = "@#{column}"
              instance_variable_set("@save_queryset", {}) unless @save_queryset
              @save_queryset[column] = val unless column == "id"
              instance_variable_set(instance_var, val)
            end

            define_method(column) do
              instance_var = "@#{column}"
              instance_variable_get(instance_var)
            end
          end
        end

        def create(options={})
          keys = options.keys.join(", ")
          values = options.values
          placeholders = Array.new(values.size, "?").join(", ")
          Connection.connect.execute("INSERT INTO #{table_name} (#{keys}) VALUES (#{placeholders})", values)
          self.last
        end

        def table_name
          self.to_s.downcase + "s"
        end

        def all
          add_query("SELECT", "*") unless @@queryset && @@queryset["SELECT"]
          fetch_result
        end

        def find(id)
          find_by(id: id)
        end

        def find_by(options = {})
          where(options)
          fetch_result.first
        end

        def where(options = {})
          sql = ""
          options.each {|key, val| sql << "#{key.to_s} = '#{val}'"}
          add_query("WHERE",  sql)
        end

        def select(val)
          add_query("SELECT", val)
        end

        def count
          result = all
          result.size
        end

        def first
          limit(1)
          fetch_result.first
        end

        def last
          limit(1).order("id DESC")
          fetch_result.first
        end

        def limit(val)
          @@queryset["LIMIT"] = val
          self
        end

        def order(val)
          @@queryset["ORDER BY"] = val
          self
        end

        def destroy(id)
          destroy_all("WHERE id = #{id}")
        end

        def destroy_all(xtra = "; VACUUM")
          query = "DELETE FROM #{table_name} #{xtra}"
          execute(query)
          self
        end

        def update_queryset(key, value)
          @@queryset ||= {}
          @@queryset[key] = @@queryset[key] ?  @@queryset[key] << value : [value]
        end

        def fetch_result
          result = process_query(@@queryset)
          @@queryset = {}
          parse_result_to_objects(result)
        end
      end
    end
  end
end
