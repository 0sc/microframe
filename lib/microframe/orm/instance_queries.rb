module Microframe
  module ORM
    module InstanceQueries
      def save
        @save_queryset["id"] = id
        keys = @save_queryset.keys.join(", ")
        values = @save_queryset.values
        @save_queryset = nil
        placeholders = Array.new(values.size, "?").join(", ")
        result = Microframe::ORM::Connection.connect.execute("REPLACE INTO #{table_name} (#{keys}) VALUES (#{placeholders})", values)
        result ? self.class.last : self
      end

      def update(options = {})
        @save_queryset ||= {}
        @save_queryset.merge!(options)
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
