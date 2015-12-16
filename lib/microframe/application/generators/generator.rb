require "thor"

module Microframe
  class Generator < Thor
    include Thor::Actions

    attr_reader :app_name, :type, :name, :xtras

    def self.source_root
      File.join(__dir__, "samples")
    end

    desc "new NAME", "Creates a new Microframe project called NAME"
    def new(name)
      @app_name = name
      directory("app_sample", "#{app_name}")
    end

    desc "generate TYPE NAME OPTIONS", "Generates microframe resource of TYPE (i.e. model, controller or view) with the given NAME extra options specific to TYPE can also be provided"
    def generate(type, name, *xtras)
      @type = type.downcase
      @name = name.downcase
      @xtras = xtras

      if type == "controller"
        template("sample_controller.tt", File.join(target_root, "controllers", "#{name}_controller.rb"))
        generate("view", name)
      elsif type == "model"
        template("sample_model.tt", File.join(target_root, "models", "#{name}.rb"))
      elsif type == "view"
        directory("folder", File.join(target_root, "views", "name"))
      end
    end

    desc "g TYPE NAME OPTIONS", "alias for microframe generate"
    def g(type, name, *xtras)
      invoke :generate, [type, name, *xtras]
    end

    private

    def target_root
      "app/"
    end

  end
end
