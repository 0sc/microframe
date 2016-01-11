module Microframe
  module ORM
    class Errors
      def initialize
        @errors = []
      end

      def add(error)
        @errors << error
      end

      def fetch_errors
        @errors
      end

      def clear_errors
        @errors = []
      end
    end
  end
end
