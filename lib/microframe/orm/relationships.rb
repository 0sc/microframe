module Microframe
  module ORM
    module Relationships

      def has_many(model, options = {})
        model = model.to_s
        define_method(model) do
          model_class = model[0..-2]
          options[:foreign_key] ||= self.class.to_s.downcase + "_id"
          Module.const_get(model_class.capitalize).where(options[:foreign_key] => id )
        end
      end

      def belongs_to(model, options = {})
        define_method(model) do
          options[:foreign_key] ||= "id"
          model_id = send("#{model}_id")
          Module.const_get(model.to_s.capitalize).where(options[:foreign_key] => model_id ).fetch.first
        end
      end

      # def validates
      #   "With love from validates to"
      # end
    end
  end
end
