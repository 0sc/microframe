require File.join(__dir__,"queryset")
require File.join(__dir__,"relationships")

module Microframe
  module ORM
    class Base
      class << self
        include Relationships

        def inherited(base)
          base.include InstanceQueries
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
          init_queryset(:select, "*").fetch
        end

        def find(id)
          find_by(id: id).fetch.first
        end

        def find_by(options)
          init_queryset(:find_by, options).fetch.first
        end

        def where(options)
          init_queryset(:where, options)
        end

        def select(val)
          init_queryset(:select, val)
        end

        def count
          all.fetch.size
        end

        def first
          limit(1).fetch.first
        end

        def last
          limit(1).order("id DESC").fetch.first
        end

        def limit(val)
          init_queryset(:limit, val)
        end

        def order(val)
          init_queryset(:limit, val)
        end

        def destroy(id)
          destroy_all("WHERE id = #{id}")
        end

        def destroy_all(xtra = "; VACUUM")
          query = "DELETE FROM #{table_name} #{xtra}"
          Connection.connect.execute(query)
          self
        end

        def init_queryset(mtd, option)
          Queryset.new(self).send(mtd, option)
        end
      end
    end
  end
end
