# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'
require 'rubocop/rake_task'

Minitest::TestTask.create
RuboCop::RakeTask.new

desc 'Run the test suite and gather code coverage'
task :coverage do
  ENV['COVERAGE'] = '1'
  Rake::Task['test'].invoke
end

task default: %i[test rubocop]
