# frozen_string_literal: true

require "bundler/gem_tasks"

require "sdoc"
require "rdoc/task"
RDoc::Task.new do |doc|
  doc.main = "README.md"
  doc.title = "RefinementMonkey #{RefinementMonkey::VERSION} Documentation"
  doc.rdoc_dir = "doc"
  doc.generator = "sdoc"
  doc.markup = "tomdoc"
  doc.rdoc_files = FileList.new %w[lib/**/*.rb *.md LICENSE.txt]
end
task docs: %i[generate]

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

task default: %i[test rubocop]
