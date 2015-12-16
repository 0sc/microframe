module Microframe
  class Generator < Thor
    include Thor::Actions

    attr_reader :app_name, :type, :name, :xtras

    def self.source_root
      __dir__
    end

    desc "Microframe new NAME", "Creates a new Microframe project called NAME"
    def new(name)
      @app_name = name
      directory("samples/app_sample", "#{app_name}")
    end
  end
end
