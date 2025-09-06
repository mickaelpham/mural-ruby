# frozen_string_literal: true

require 'test_helper'

class TestError < Minitest::Test
  def test_error_with_details
    details = [
      {
        'code' => 'Invalid property',
        'message' => 'Invalid "widgets" property type was sent. Type ' \
                     'undefined was expected.'
      }
    ]

    err = Mural::Error.new('Invalid payload', code: 'BODY', details: details)

    # Hash#inspect rendering have been changed. [Bug #20433]
    # https://www.ruby-lang.org/en/news/2024/12/25/ruby-3-4-0-released/
    expected =
      if RUBY_VERSION.start_with?(/3\.(2|3)/)
        '#<Mural::Error message="Invalid payload" code="BODY" details=' \
          '[{"code"=>"Invalid property", "message"=>"Invalid \"widgets\" ' \
          'property type was sent. Type undefined was expected."}]>'
      else
        '#<Mural::Error message="Invalid payload" code="BODY" details=' \
          '[{"code" => "Invalid property", "message" => "Invalid \"widgets\" ' \
          'property type was sent. Type undefined was expected."}]>'
      end

    assert_equal expected, err.inspect
  end
end
