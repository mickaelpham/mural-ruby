# frozen_string_literal: true

module Mural
  class SearchRoomResult
    include Mural::Codec

    # https://developers.mural.co/public/reference/searchrooms
    define_attributes(
      id: 'id',
      name: 'name',
      description: 'description',
      type: 'type',
      workspace_id: 'workspaceId'
    )
  end
end
