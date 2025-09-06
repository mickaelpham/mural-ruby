# frozen_string_literal: true

require 'test_helper'

class TestMuralContent < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_asset
    mural_id = 'some-mural-2'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/assets"
    )
      .with(body: { assetType: 'file', fileExtension: 'pdf' })
      .to_return_json(
        body: { value: {
          name: 'some-filename.pdf',
          url: 'https://foobar.com/path',
          headers: { 'x-ms-blob-type' => 'BlockBlob' }
        } },
        status: 201
      )

    asset = @client.mural_content.create_asset(
      mural_id,
      file_extension: 'pdf',
      asset_type: 'file'
    )

    assert_instance_of Mural::Asset, asset
    assert_equal 'some-filename.pdf', asset.name
    assert_equal 'https://foobar.com/path', asset.url
    assert_equal 'BlockBlob', asset.headers.blob_type
  end
end
