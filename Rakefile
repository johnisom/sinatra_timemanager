# frozen_string_literal: true

require 'rake/testtask'
require 'find'

desc 'Rubocop, bye_emacs, test, and super_git all in one'
task :super, [:message] do |_, args|
  Rake::Task[:rubocop].execute
  Rake::Task[:bye_emacs].execute
  Rake::Task[:test].execute
  Rake::Task[:super_git].execute(message: args.message)
end

desc 'Run tests'
task default: :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/*_test.rb']
end

Rake::TestTask.new(:test_signed_in) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/*_in_test.rb']
end

Rake::TestTask.new(:test_signed_out) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/*_out_test.rb']
end

desc 'Display inventory of all visible files in the project'
task :inventory do
  sh 'tree -CF --dirsfirst'
end

desc 'Alias of inventory'
task tree: :inventory

desc 'Automatically fix simple errors with rubocop'
task :rubocop, [:option] do |_, args|
  case args[:option]
  when 'no-fix' then sh 'rubocop .'
  else sh 'rubocop -a .'
  end
rescue RuntimeError => e
  abort unless e.message =~ /Command failed with status/
end

desc 'Give wc info for all files in the project that I wrote.'
task :wc do
  files = %w[Rakefile
             Gemfile
             Procfile
             config.ru
             README.md
             time_manager.rb
             data/test.yml
             public/stylesheets/time_manager.css] +
          Dir['test/*.rb'] +
          Dir['lib/*.rb'] +
          Dir['views/*.erb']

  sh "wc #{files.join(' ')}"
end

desc 'Remove all emacs backup files'
task :bye_emacs do
  files = Dir['**/*~'].join(' ')
  sh "rm #{files}" unless files.empty?
end

desc 'Add all files and commit with message, pushing to remote repos.'
task :super_git, [:message] do |_, args|
  remotes = `git remote`.split
  sh 'git add .'
  sh %(git commit -m "#{args[:message]}")
  remotes.each { |remote| sh "git push #{remote}" }
end
