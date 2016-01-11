module Microframe
  class ViewObject
    include Helpers
    def initialize(obj)
      @main_obj = obj
    end

    def render_partial(option)
      @main_obj.render_partial(option)
    end
  end
end
