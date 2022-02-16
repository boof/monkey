# frozen_string_literal: true

# :markup: TomDoc

patch String do
  UNDERSCOPE_SUB_CHARS  = /[A-Z-]|::/
  UNDERSCORE_CAP_GROUPS = /([A-Z]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/

  # String#first
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
  #
  # Returns first +len+ characters of self.
  def first(len = 1)
    raise ArgumentError, "negative string size" if len.negative?

    return if empty?
    return "" if len.zero?

    slice(...len)
  end

  # String#last
  #
  # len - Number of characters returned.
  #
  # Examples
  #
  #   refinement_monkey.learn String
  #   using refinement_monkey["String#last"] | refinement_monkey/String
  #
  #   "Hello World!".last # => "!"
  #   "Hello World!".last 3 # => "ld!"
  #   "Hello World!".last -2 # => ArgumentError
  #
  # Returns last +len+ characters of self.
  def last(len = 1)
    raise ArgumentError, "negative string size" if len.negative?

    return if empty?
    return "" if len.zero?

    slice(-len..)
  end

  # String#underscore
  #
  # This method will also change +::+ to +File::SEPARATOR+ to convert namespaces to paths.
  #
  # Examples
  #
  #   refinement_monkey.learn String
  #   using refinement_monkey["String#underscore"] | refinement_monkey/String
  #
  #   'RefinementMonkey'.underscore            # => "refinement_monkey"
  #   'RefinementMonkey::Teachings'.underscore # => "refinement_monkey/teachings"
  #
  # Returns an underscored, lowercased form from the expression in the string.
  def underscore
    return self unless match? UNDERSCOPE_SUB_CHARS

    word = gsub "::", File::SEPARATOR
    word = word.gsub(UNDERSCORE_CAP_GROUPS) { (Regexp.last_match(1) || Regexp.last_match(2)) << "_" }
    word = word.tr "-", "_"

    word.downcase
  end
end
