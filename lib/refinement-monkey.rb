# frozen_string_literal: true
# :markup: TomDoc

require "refinement-monkey/method_wrapper"
require "refinement-monkey/refinements"
require "refinement-monkey/registry"
require "refinement-monkey/teachings"
require "refinement-monkey/version"

class RefinementMonkey
  Error = Module.new
  ArgumentError = Class.new(::ArgumentError) { include Error }
  KeyError      = Class.new(::KeyError)      { include Error }
  NoMethodError = Class.new(::NoMethodError) { include Error }

  def initialize(path: nil)
    @registry  = Registry.new
    @teachings = Teachings.new self, **{ path: }.compact
  end
  @instance = new

  # rubocop:disable Naming/BlockForwarding

  # Public: Register a new patch.
  #
  # object - The refined object (eg. Module, Class) or Method (also UnboundMethod).
  #
  # Examples
  #
  #   Monkey.patch Kernel do
  #     def pp(*args)
  #       ...
  #     end
  #   end
  #   Monkey.patch Kernel.instance_method(:pp) do
  #     ..
  #   end
  #
  # Returns nothing.
  def patch(object, &block)
    owner, collection = collect object, &block
    MethodWrapper.each_method(owner, collection) { @registry.patches _1 }

    nil
  end
  # rubocop:enable Naming/BlockForwarding

  # Public: Learn new patches, see RefinementMonkey::Teachings.
  #
  # names - List of symbols.
  #
  # Examples
  #
  #   Monkey.learn String, Array
  #
  # Returns names.
  def learn(*names)
    names.each { @teachings.read _1 }
  end

  # Public: Loads all refinements into a Refinements module.
  #
  # Examples
  #
  #   using Monkey.patches
  #
  # Returns a Refinements module.
  def patches
    Refinements.new @registry.values
  end

  # Public: Loads specific method matching sig into a Refinements module.
  #
  # sig - Signature for specific method.
  #
  # Examples
  #
  #   using Monkey["Array#min_of"]
  #
  # Returns a Refinements module.
  def [](sig)
    Refinements.new @registry.fetch(sig)
  end

  # Public: Loads all refinements for owner into a Refinements module.
  #
  # Examples
  #
  #   using Monkey/String
  #
  # Returns a Refinements module.
  def /(owner) # rubocop:disable Naming/BinaryOperatorParameterName
    Refinements.new @registry.values_at(owner)
  end

  # Public: See Registry#pretty_print
  def pretty_print(...)
    @registry.pretty_print(...)
  end

  # Public: See Registry#inspect
  def inspect
    @registry.inspect
  end

  # Public: See Registry#to_s
  def to_s
    @registry.to_s
  end

  private

  def collect(object, &)
    case object
    when Module
      [object, Module.new(&)]
    when Method
      [object.owner, Module.new { define_singleton_method(object.name, &) }]
    when UnboundMethod
      [object.owner, Module.new { define_method(object.name, &) }]
    else
      raise ArgumentError
    end
  end
end
