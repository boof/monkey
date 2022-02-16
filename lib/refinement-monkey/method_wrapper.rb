# frozen_string_literal: true

# :markup: TomDoc
class RefinementMonkey
  class MethodWrapper
    def self.each_method(owner, source)
      source.singleton_methods(false).each { yield singleton_method(owner, source, _1) }
      source.instance_methods(false).each { yield instance_method(owner, source, _1) }
    end

    def self.singleton_method(owner, source, name)
      method = source.singleton_method name

      i12n = Module.new do
        define_method(:name) { ".#{name}" }
        define_method(:copy_to) { _1.define_method name, &method }
      end

      new(owner, owner.singleton_class, method).extend i12n
    end

    def self.instance_method(owner, source, name)
      method = source.instance_method name

      i12n = Module.new do
        define_method(:name) { "##{name}" }
        define_method(:copy_to) { _1.define_method name, method }
      end

      new(owner, owner, method).extend i12n
    end

    attr_reader :owner, :target

    def initialize(owner, target, callable)
      @owner    = owner
      @target   = target
      @callable = callable
    end

    # Composes a method signature from owner's and method's name, but w/o arguments.
    #
    # Examples
    #
    #   "Monkey::MethodWrapper.each_method"
    #   "Monkey::MethodWrapper#sig"
    #
    # Returns method signature w/o arguments.
    def sig
      "#{@owner.name}#{name}"
    end
    alias to_s sig

    # Composes method inspection.
    #
    # Examples
    #
    #   "Monkey::MethodWrapper.each_method[2] at .../lib/refinement-monkey/method_wrapper.rb:6"
    #   "Monkey::MethodWrapper#inspect[0] at .../lib/refinement-monkey/method_wrapper.rb:62"
    #
    # Returns method signature.
    def inspect
      "#{self}[#{@callable.arity}] at #{@callable.source_location.join ":"}"
    end

    def pretty_print(q) # rubocop:disable Naming/MethodParameterName
      inspect.pretty_print q
    end
  end
end
