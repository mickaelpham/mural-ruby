# frozen_string_literal: true

require 'forwardable'
require 'json'
require 'net/http'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module Mural
  class Error < StandardError
    attr_reader :code, :details

    def initialize(message, code:, details: nil)
      @code = code
      @details = details

      super(message)
    end

    def inspect
      "#<Mural::Error message=#{message.inspect} code=#{code.inspect} " \
        "details=#{details.inspect}>"
    end
  end
end
