# frozen_string_literal: true

require 'test_helper'

class TestVersion < Minitest::Test
  def test_it_has_a_version
    refute_nil Mural::VERSION
  end
end
