# frozen_string_literal: true

module Mural
  class CreateRoomParams
    include Mural::Codec

    # https://developers.mural.co/public/reference/createroom
    define_attributes(
      confidential: 'confidential',
      description: 'description',
      name: 'name',
      type: 'type',
      workspace_id: 'workspaceId'
    )
  end
end
