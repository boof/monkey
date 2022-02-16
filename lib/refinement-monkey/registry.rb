# frozen_string_literal: true

class RefinementMonkey
  class Registry
    include Enumerable

    def initialize
      @map = Hash.new { |mem, owner| mem[owner] = {} }
      @sig = {}
    end

    def patches(method)
      @map[method.owner][method.name] = @sig[method.sig] = method
    end

    def each
      @map.each { |_, methods| methods.values.each { yield _1 } }
    end

    def values
      group_by_target @map.values.flat_map(&:values)
    end

    def values_at(owner)
      raise KeyError unless @map.key? owner

      group_by_target @map[owner].values
    end

    def dig(owner, name)
      group_by_target @map.dig(owner, name)
    end

    def fetch(sig)
      @sig.fetch(sig).then { group_by_target [_1] }
    rescue ::KeyError
      owner, method = sig.split(/[.#]/)
      raise NoMethodError, "undefined method `#{method}' for #{owner}" # RADAR: Did you mean?
    end

    # Public: Support for PP output.
    #
    # Returns a pretty printed Array of all registered patches.
    def pretty_print(...)
      @map.flat_map { |_, m| m.values.map { _1.pretty_print(...) } }.pretty_print(...)
    end

    # Public: Inspects all registered methods.
    #
    # Returns a inspected Array of all registered patches.
    def inspect
      @map.flat_map { |_, m| m.values }.inspect
    end

    # Public: Lists all signatures.
    #
    # Returns an Array of signatures of all registered patches.
    def to_s
      @map.flat_map { |_, m| m.values.map(&:sig) }.to_s
    end

    private

    def group_by_target(methods)
      map = Hash.new { |h, k| h[k] = [] }
      methods.each { map[_1.target] << _1 }

      map
    end
  end
end
