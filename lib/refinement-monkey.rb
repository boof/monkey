# frozen_string_literal: true

require "refinement-monkey/method_wrapper"
require "refinement-monkey/refinements"
require "refinement-monkey/repository"
require "refinement-monkey/teachings"
require "refinement-monkey/version"

# :markup: TomDoc
class RefinementMonkey
  Error = Module.new
  ArgumentError = Class.new(::ArgumentError) { include Error }
  KeyError      = Class.new(::KeyError)      { include Error }
  NoMethodError = Class.new(::NoMethodError) { include Error }

  def initialize(path: nil)
    @repository = Repository.new
    @teachings  = Teachings.new self, **{ path: }.compact
  end
  @instance = new

  # rubocop:disable Naming/BlockForwarding

  private def collect(object, &)
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
    MethodWrapper.each_method(owner, collection) { @repository.commit _1 }

    nil
  end
  # rubocop:enable Naming/BlockForwarding

  private def read(name)
    @teachings.read name
  end
  @instance.__send__ :read, "string"

  # Public: Loads all refinements into a Refinements module.
  #
  # Examples
  #
  #   using Monkey.patches
  #
  # Returns a Refinements module.
  def patches
    Refinements.new @repository.values
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
    Refinements.new @repository.fetch(sig)
  end
  using @instance["String#underscore"]

  # Public: Loads all refinements for owner into a Refinements module.
  #
  # Examples
  #
  #   using Monkey/String
  #
  # Returns a Refinements module.
  def /(owner) # rubocop:disable Naming/BinaryOperatorParameterName
    Refinements.new @repository.values_at(owner)
  end

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
    names.each { read _1.to_s.underscore }
  end

  # Public: Support for PP output.
  #
  # Returns a pretty printed Array of all registered patches.
  def pretty_print(...)
    @repository.pretty_print(...)
  end

  # Public: Inspects all registered methods.
  #
  # Returns a inspected Array of all registered patches.
  def inspect
    @repository.inspect
  end

  # Public: Lists all signatures.
  #
  # Returns all signatures of commited methods.
  def to_s
    @repository.to_s
  end
end
