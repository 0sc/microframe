require File.join(__dir__,"class_queries")
require File.join(__dir__,"instance_queries")
require File.join(__dir__,"errors")

Dir[File.join(APP_PATH, "app", "models", "*.rb")].each { |file| require file}

module Microframe
  module ORM
    class Base
      attr_reader :error
      def initialize(options = {})
        options.each{ |col, val| send("#{col}=", val) }
        @error = Errors.new
      end

      def table_name
        self.class.table_name
      end
    end
  end
end
