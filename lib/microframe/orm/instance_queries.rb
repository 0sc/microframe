module Microframe
  module ORM
    module InstanceQueries
      include QueryUtils
      def save
        queryset = {}
        models_columns.each { |col| queryset[col] = send(col) }
        validate(queryset)
        errors.empty? ? execute_save(queryset) : false
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

      def validate(queryset)
        validator.set_object(self)
        queryset.each { |key, val| validator.validate(key, val) }
        validator.custom_validation
      end

      def execute_save(queryset)
        keys = queryset.keys.join(", ")
        values = queryset.values
        placeholders = Array.new(values.size, "?").join(", ")
        result = Connection.connection.execute("REPLACE INTO #{table_name} (#{keys}) VALUES (#{placeholders})", values)
        result ? self.class.last : self
      end

      def errors
        error.fetch_errors
      end

      def validator
        @validator ||= self.class.validators(table_name)
        @validator
      end
    end
  end
end
