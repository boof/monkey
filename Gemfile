# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in monkey.gemspec
gemspec

group :guard do
  gem "guard"
  gem "guard-minitest"
  gem "guard-rake"
  gem "guard-rubocop"
end

gem "minitest", "~> 5.0"

gem "rake", "~> 13.0"

group :rdoc do
  gem "rdoc"
  gem "sdoc"
end

group :rubocop do
  gem "rubocop", "~> 1.7"
  gem "rubocop-minitest", require: false
  gem "rubocop-rake", require: false
end
