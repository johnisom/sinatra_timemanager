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
task :rubocop, [:arg] do |_, args|
  case args[:arg]
  when 'no-fix' then sh 'rubocop .'
  else sh 'rubocop -a .'
  end
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
  sh "rm #{files}"
end

desc 'Add all files and commit with message, pushing to heroku and origin repos.'
task :super_git, [:message] do |_, args|
  message = args[:message]
  sh "git add ."
  sh "git commit -m #{message}"
  sh "git push heroku master"
  sh "git push origin master"
end
