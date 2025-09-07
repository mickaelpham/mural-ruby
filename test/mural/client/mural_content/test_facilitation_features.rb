# frozen_string_literal: true

class TestFacilitationFeatures < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_start_private_mode
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/private-mode/start"
    )
      .with(body: { hideAuthors: true })
      .to_return_json(
        body: {
          value: {
            active: true,
            initialTimestamp: 1,
            startedBy: 'user-1',
            hideAuthors: true
          }
        }
      )

    private_mode =
      @client.mural_content.start_private_mode(mural_id, hide_authors: true)

    assert_instance_of Mural::PrivateMode, private_mode
    assert_equal 'user-1', private_mode.started_by
    assert private_mode.hide_authors
  end
end
