# frozen_string_literal: true

require "test_helper"

Monkey = RefinementMonkey.new

Monkey.patch RefinementMonkey do
  def version
    RefinementMonkey::VERSION
  end

  def self.diet
    "bananas"
  end
end

Monkey.patch Minitest::Assertions do
  def assert_hello_world(actual)
    assert_equal "Hello World!", actual
  end
end

Monkey.patch Kernel do
  def hello_world
    "Hello World!"
  end
end

Monkey.learn Array, String

class RefinementMonkeyTest < Minitest::Test
  # rubocop:disable Layout/SpaceAroundOperators
  using Monkey["RefinementMonkey#version"] |
        Monkey/RefinementMonkey |
        Monkey["Array#max_of"] |
        Monkey/String |
        Monkey/Kernel |
        Monkey["Minitest::Assertions#assert_hello_world"]
  # rubocop:enable Layout/SpaceAroundOperators

  def test_refined_monkey
    assert Monkey.version
    assert_equal "bananas", RefinementMonkey.diet
  end

  def test_refined_assertions_and_kernel
    assert_hello_world hello_world
  end

  def test_refined_array
    assert_equal 5, [(1..5), (3..5), (5..7), (1..3)].max_of(:min)
    refute_respond_to [], :min_of
  end

  def test_refined_string
    assert_equal "He", hello_world.first(2)
    assert_equal "!", hello_world.last
  end

  def test_inspect
    expected = Monkey.patches.map.values.flatten.inspect
    assert_equal expected, Monkey.inspect
  end

  def test_to_string
    expected = Monkey.patches.map.values.flatten.map(&:sig).to_s
    assert_equal expected, Monkey.to_s
  end
end
