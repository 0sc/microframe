module Microframe
  module ORM
    class Validation
      attr_reader :rules, :errors
      def initialize(table)
       @rules = {}
       @custom_rules = []
       @model_obj = Module.const_get(table.capitalize.chop)
      end

      def presence(field, value, condition)
        if condition && (value.nil? || value.empty?)
          add_error "#{field} cannot be empty."
        end
      end

      def absence(field, value, condition)
        if condition && !value.nil? && !value.empty?
          add_error "#{field} must be empty."
        end
      end

      def length(field, value, condition)
        val_length = value.length
        if condition[:maximum] && val_length > condition[:maximum]
          max = condition[:maximum]
          add_error "#{field} is too long (maximum is #{max} characters)."
        end

        if condition[:minimum] && val_length < condition[:minimum]
          min = condition[:minimum]
          add_error "#{field} is too long (minimum is #{min} characters)."
        end

        if condition[:in] && !condition[:in].member?(val_length)
          add_error "#{field} length is not within the given range. (range is #{condition[:in]} characters)."
        end

        if condition[:is] && val_length != condition[:is]
          add_error "#{field} length is not the expected length (expected length is #{condition[:is]} characters)."
        end

      end

      def inclusion(field, value, condition)
        if condition[:in] && !condition[:in].include?(value)
          add_error "#{value} is not included in the list."
        end

        if condition[:within] && !condition[:within].include?(value)
          add_error "#{value} is not included in the list."
        end
      end

      def exclusion(field, value, condition)
        if condition[:in] && condition[:in].include?(value)
          add_error "#{value} is reserved."
        end

        if condition[:within] && condition[:within].include?(value)
          add_error "#{value} is reserved."
        end
      end

      def numericality(field, value, condition)
        if condition[:only_integer]
          msg = "#{field} is not an integer."
          add_error msg unless /\A[+-]?\d+\z/.match(value.to_s)
        else
          msg = "#{field} is not an number."
          add_error msg unless /\A[+-]?\d+(?:\.\d+)?\z/.match(value.to_s)
        end

        if condition[:greater_than] && value <= condition[:greater_than]
          add_error "#{field} must be greater than #{condition[:greater_than]}."
        end

        if condition[:greater_than_or_equal_to] && value < condition[:greater_than_or_equal_to]
          add_error "#{field} must be greater than or equal to #{condition[:greater_than_or_equal_to]}."
        end

        if condition[:less_than] && value >= condition[:less_than]
          add_error "#{field} must be less than #{condition[:less_than]}."
        end

        if condition[:less_than_or_equal_to] && value > condition[:less_than_or_equal_to]
          add_error "#{field} must be less than or equal to #{condition[:less_than_or_equal_to]}."
        end
      end

      def uniqueness(field, value, condition)
        if condition && @model_obj.find_by(field.downcase => value)
          add_error "#{value} has already been take."
        end
      end

      def with(field, value,condition)
        @this_obj.send(condition)
      end

      def add(col, options)
        @rules[col] = {} unless @rules[col]
        @rules[col].merge!(options)
      end

      def add_custom(rule)
        @custom_rules << rule
      end

      def validate(field, value)
        field_rules = @rules[field.to_sym]
        field = field.capitalize
        return unless field_rules
        field_rules.each do |mtd, condition|
          send(mtd, field, value, condition)
        end
      end

      def custom_validation
        @custom_rules.each { |rule| @this_obj.send(rule) }
      end

      def set_object(obj)
        @this_obj = obj
        obj.error.clear_errors
      end

      def add_error(err)
        @this_obj.error.add(err)
      end
    end
  end
end
