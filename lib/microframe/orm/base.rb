require File.join(__dir__,"class_queries")
require File.join(__dir__,"instance_queries")

Dir[File.join(".", "app", "models", "*.rb")].each { |file| require file}

module Microframe
  module ORM
    class Base
      def table_name
        self.class.table_name
      end
    end
  end
end
