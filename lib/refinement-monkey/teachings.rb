# frozen_string_literal: true

require "set"

class RefinementMonkey
  class Teachings
    PATH = File.join __dir__, "teachings"

    attr_reader :path, :seen

    def initialize(monkey, path: PATH)
      @monkey = monkey
      @path   = path

      @mutex  = Mutex.new
      @seen   = Set.new
    end

    def read(name)
      @mutex.synchronize do
        next if seen.member? name

        monkey  = @monkey
        context = Module.new do
          define_method :patch, ->(o, &b) { monkey.patch(o, &b) }
        end

        owner_path = File.join path, "#{name}.rb"
        load owner_path, context

        seen << name
      end
    end
  end
end
