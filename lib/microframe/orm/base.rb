require File.join(__dir__,"class_queries")
Dir[File.join(".", "app", "models", "*.rb")].each { |file| require file}

module Microframe
  module ORM
    class Base

      def update_queryset(key, value)
        @queryset ||= Hash.new(Array.new)
        @queryset[key] = @queryset[key] << value
      end

      def table_name
        self.class.table_name
      end
    end
  end
end
