# frozen_string_literal: true

require 'rake/testtask'
require 'find'

desc 'Run tests'
task default: :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/*_test.rb']
end

desc 'Display inventory of all visible files in the project'
task :inventory do
  sh 'tree -CF --dirsfirst'
end

desc 'Alias of inventory'
task tree: :inventory

desc 'Automatically fix simple errors with rubocop'
task :rubocop, [:arg] do |_, args|
  case args[:arg]
  when 'no-fix' then sh 'rubocop .'
  else sh 'rubocop -a .'
  end
end
