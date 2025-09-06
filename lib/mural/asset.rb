# frozen_string_literal: true

module Mural
  class Asset
    include Mural::Codec

    # https://developers.mural.co/public/reference/createasset
    define_attributes(
      name: 'name',
      url: 'url',
      headers: 'headers'
    )

    def self.decode(json)
      super.tap do |asset_url|
        asset_url.headers = Headers.decode(asset_url.headers)
      end
    end

    class Headers
      include Mural::Codec

      define_attributes(blob_type: 'x-ms-blob-type')
    end
  end
end
