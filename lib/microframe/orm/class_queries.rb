require File.join(__dir__, "queryset")
require File.join(__dir__, "relationships")
require File.join(__dir__, "validation")

module Microframe
  module ORM
    class Base
      @@create_table_query = []
      @@validation = {}
      class << self
        include Relationships

        def inherited(base)
          base.include InstanceQueries
        end

        def property(col_name, options = {})
          pkey = "PRIMARY KEY AUTOINCREMENT"
          options[:type] = options[:type].to_s.upcase
          options[:nullable] = options[:nullable] ? "NULL" : "NOT NULL"
          options[:primary_key] = options[:primary_key] ? pkey : ""
          get_create_table_query << (col_name.to_s + " " +
          options.values.join(" "))
        end

        def validates(col, options = {})
          validators(table_name).add(col, options)
        end

        def validate_with(mtd)
          validators(table_name).add_custom(mtd)
        end

        def validators(table)
          @@validation[table] ||= Validation.new(table_name)
          @@validation[table]
        end

        def all_validators
          @@validation
        end

        def get_create_table_query
          @@create_table_query
        end

        def create_table
          query = "CREATE TABLE IF NOT EXISTS #{table_name} "\
          "(#{get_create_table_query.join(', ')})"
          if Connection.execute(query)
            @@create_table_query = []
            define_attributes
          end
        end

        def define_attributes
          save_data = []
          Connection.retrieve_columns(table_name).each do |column|
            save_data << column
            define_method("#{column}=") do |val|
              instance_var = "@#{column}"
              instance_variable_set(instance_var, val)
            end

            define_method(column) do
              instance_var = "@#{column}"
              instance_variable_get(instance_var)
            end
          end

          define_method("models_columns") do
            save_data
          end
        end

        def create(options = {})
          new(options).save
        end

        def table_name
          to_s.downcase + "s"
        end

        def all
          init_queryset(:select, "*").fetch
        end

        def find(id)
          find_by(id: id)
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
          all.size
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
          init_queryset(:order, val)
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
