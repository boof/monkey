# frozen_string_literal: true

require_relative "lib/refinement-monkey/version"

Gem::Specification.new do |spec|
  spec.name          = "refinement-monkey"
  spec.version       = RefinementMonkey::VERSION
  spec.authors       = ["Florian Aßmann"]
  spec.email         = ["florian@yni.onl"]

  spec.summary       = "Ruby Refinement Monkey"
  spec.description   = "Monkey that manages your refinements and helps you to select and bundle specific refinements."
  spec.homepage      = "https://monkey-patch.me"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.1.0")

  spec.metadata["allowed_push_host"] = "http://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/boof/refinement-monkey"
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/boof/refinement-monkey/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
