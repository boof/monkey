Bundler.require :guard

guard :minitest do
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$}) { 'test' }
end

guard :rubocop, all_on_start: false, cli: ['--format', 'clang', '--display-cop-names'] do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
end

guard 'rake', :task => 'rerdoc', run_on_all: false do
  watch(%r{.+\.md$})
  watch(%r{^lib/.+\.rb$})
end
