# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      extend Forwardable

      include Areas
      include Arrows
      include Chats
      include FacilitationFeatures
      include Files
      include StickyNotes
      include Tags
      include Widgets

      def_delegators :@client, :get, :post, :patch, :delete

      def initialize(client)
        @client = client
      end

      # https://developers.mural.co/public/reference/createasset
      def create_asset(mural_id, file_extension:, asset_type: nil)
        json = post(
          "/api/public/v1/murals/#{mural_id}/assets",
          { assetType: asset_type, fileExtension: file_extension }
        )

        Mural::Asset.decode(json['value'])
      end
    end
  end
end
