# frozen_string_literal: true

patch String do
  # RefinementMonkeyPatches: Returns first `len` characters of self.
  #
  # len - Number of characters returned.
  #
  # Examples
  #
  #   refinement_monkey.learn String
  #   using refinement_monkey["String#first"] | refinement_monkey/String
  #
  #   "Hello World!".first # => "H"
  #   "Hello World!".first 3 # => "Hel"
  #   "Hello World!".first -2 # => ArgumentError
  def first(len = 1)
    raise ArgumentError, "negative string size" if len.negative?

    return if empty?
    return "" if len.zero?

    slice(...len)
  end

  def last(len = 1)
    raise ArgumentError, "negative string size" if len.negative?

    return if empty?
    return "" if len.zero?

    slice(-len..)
  end
end
