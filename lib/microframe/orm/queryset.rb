require File.join(__dir__,"query_utils")

module Microframe
  module ORM
    class Queryset
      include QueryUtils

      attr_reader :queryset

      def initialize(model)
        @queryset = {}
        @table_name = model.table_name
        @model = model
      end

      def where(options)
        sql = []
        options.each {|key, val| sql << "#{key.to_s} = '#{val}'"}
        add_query("WHERE",  sql.join(" AND "))
      end

      def all(val = "*")
        add_query("SELECT", "#{val}") unless queryset["SELECT"]
        fetch
      end

      def find(id)
        where(id: id)
      end

      def find_by(option)
        where(option)
      end

      def select(val)
        add_query("SELECT", val)
      end

      def limit(val)
        @queryset["LIMIT"] = val
        self
      end

      def order(val)
        @queryset["ORDER BY"] = val
        self
      end

      def add_query(field, condition)
        @queryset ||= {}
        @queryset[field] = queryset[field] ?  queryset[field] << condition : [condition]
        self
      end

      def fetch
        result = process_query(queryset)
        @queryset = {}
        parse_result_to_objects(result)
      end

      def load
        fetch.first
      end
    end
  end
end
