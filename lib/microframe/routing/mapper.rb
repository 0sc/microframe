module Microframe
  class Mapper
    attr_reader :routes, :placeholders
    def initialize(routes)
      @routes = routes
    end

    def self.start(route)
      new(route)
    end

    def map(verb, path)
      value = nil
      routes[verb].each do |route, target|
        if match_this(route, path)
          value = target
          break
        end
      end
      value
    end

    def match_components(a, b)
      found = false
      if a == b
        found = true
      elsif a[0] == ":" && a[-1] != ")" && a[-1] != "("
        @placeholders[a[1..-1].to_sym] = b
        found = true
      end
      return found
    end

    def match_begin_of_optional_components(a, optional)
      if a[-1] == "("
        optional += 1
        a.sub!("(", "")
        changed = true
      end
      return a, optional, changed
    end

    def match_end_of_optional_components(a, optional)
      if a[-1] == ")"
        optional -= 1
        a.sub!(")", "")
        changed = true
      end
      return a, optional, changed
    end

    def match_optional_components(match, optional, index)
      if optional > 0
        match = true
        index -= 1
      end
      return match, index, match
    end

    def match_this(routes, path)
      match = []; @placeholders = {}; index = 0;
      route = routes.split("/")
      paths = path.split("/")

      return false if route.size < paths.size

      route.each do |a|
        pending_match = true; matched = false; optional = 0;
        b = paths[index]

        while pending_match
          matched = match_components(a, b)
          pending_match = false
          a, optional, pending_match = match_begin_of_optional_components(a, optional) unless matched || pending_match
          a, optional, pending_match = match_end_of_optional_components(a, optional) unless matched || pending_match
          matched, index, pending_match = match_optional_components(matched, optional, index) unless matched || pending_match
        end

        match << matched
        index += 1
      end
      !match.include? false
    end
  end
end
