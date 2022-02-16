# frozen_string_literal: true

# :markup: TomDoc
class RefinementMonkey
  module Refinements
    # Public: Merge with another Refinments module.
    #
    # other - Another Refinments module.
    #
    # Examples
    #
    #   RefinementMonkeyPatches/Array | RefinementMonkeyPatches["String#first"]
    #
    # Returns a Refinments module.
    def |(other) end

    # Internal: Build anonymous module.
    #
    # Returns a Refinements module.
    def self.new(map)
      Module.new do
        define_singleton_method(:map) { map }
        define_singleton_method(:|) { |other| Refinements.new map.merge(other.map) { |_target, v1, v2| v1 | v2 } }

        map.each do |target, methods|
          refine(target) { methods.each { _1.copy_to self } }
        end
      end
    end
  end
end
