module Microframe
  module ORM
    module InstanceQueries
      include QueryUtils
      def save
        queryset = {}
        models_columns.each { |col| queryset[col] = send(col) }
        keys = queryset.keys.join(", ")
        values = queryset.values
        placeholders = Array.new(values.size, "?").join(", ")
        result = Connection.connection.execute("REPLACE INTO #{table_name} (#{keys}) VALUES (#{placeholders})", values)
        result ? self.class.last : self
      end

      def update(options = {})
        options.each{ |col, val| send("#{col}=", val) }
        save
      end

      def destroy
        query = "DELETE FROM #{table_name} WHERE id =#{id}"
        execute(query)
        self
      end
    end
  end
end
