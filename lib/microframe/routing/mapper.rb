module Microframe
  class Mapper
    attr_reader :routes, :placeholders
    def initialize(routes)
      @routes = routes
      @placeholders = {}
    end

    def self.start(route)
      new(route)
    end

    def map(verb, path)
      value = nil
      if routes[verb]
        routes[verb].each do |route, target|
          if match_this(route, path)
            value = target
            break
          end
        end
      end
      value
    end

    def match_components(defined_elt, incoming_elt)
      found = false
      if defined_elt == incoming_elt
        found = true
      elsif defined_elt[0] == ":" &&
            defined_elt[-1] != ")" &&
            defined_elt[-1] != "(" &&
            !incoming_elt.nil?
        @placeholders[defined_elt[1..-1].to_sym] = incoming_elt
        found = true
      end
      found
    end

    def match_begin_of_optional_components(defined_elt, optional)
      if defined_elt[-1] == "("
        optional += 1
        defined_elt.sub!("(", "")
        changed = true
      end
      [defined_elt, optional, changed]
    end

    def match_end_of_optional_components(defined_elt, optional)
      if defined_elt[-1] == ")"
        optional -= 1
        defined_elt.sub!(")", "")
        changed = true
      end
      [defined_elt, optional, changed]
    end

    def match_optional_components(match, optional, index)
      if optional > 0
        match = true
        index -= 1
      end
      [match, index, match]
    end

    def match_this(defined, incoming)
      match = []
      index = 0
      defined_route = defined.split("/")
      incoming_route = incoming.split("/")

      return false if defined_route.size < incoming_route.size

      defined_route.each do |route_elt|
        pending_match = true
        optional = 0
        incoming_elt = incoming_route[index]

        while pending_match
          matched = match_components(route_elt, incoming_elt)
          pending_match = false
          unless matched || pending_match
            route_elt, optional, pending_match =
            match_begin_of_optional_components(route_elt, optional)
          end

          unless matched || pending_match
            route_elt, optional, pending_match =
            match_end_of_optional_components(route_elt, optional)
          end

          unless matched || pending_match
            matched, index, pending_match =
            match_optional_components(matched, optional, index)
          end
        end

        match << matched
        index += 1
      end
      !match.include? false
    end
  end
end
