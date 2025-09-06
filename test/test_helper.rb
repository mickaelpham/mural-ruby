# frozen_string_literal: true

if ENV.fetch('COVERAGE', false)
  require 'simplecov'

  # https://stackoverflow.com/questions/79129198/why-does-simplecov-generate-a-coverage-report-before-running-tests
  SimpleCov.external_at_exit = true

  SimpleCov.start do
    add_filter '/test/'
    enable_coverage :branch
  end
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'mural'

require 'webmock/minitest'
require 'minitest/autorun'
