# frozen_string_literal: true

# :markup: TomDoc

patch Array do
  def max_of(key) = map(&key).max
  def min_of(key) = map(&key).min
end
