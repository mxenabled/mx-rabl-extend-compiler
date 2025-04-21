# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'mx/rabl/extend/compiler'

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec)

desc 'Run RuboCop'
task :rubocop do
  RuboCop::RakeTask.new
end

task default: %i[rubocop spec]

Dir['lib/tasks/**/*.rake'].each { |ext| load ext } if defined?(Rake)
