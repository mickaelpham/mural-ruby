# frozen_string_literal: true

require 'test_helper'

class TestVersion < Minitest::Test
  def test_it_has_a_version
    assert_equal '0.1.0', Mural::VERSION
  end
end
