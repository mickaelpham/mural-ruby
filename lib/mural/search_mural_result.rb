# frozen_string_literal: true

module Mural
  class SearchMuralResult
    include Mural::Codec

    # https://developers.mural.co/public/reference/searchmurals
    define_attributes(
      id: 'id',
      room_id: 'roomId',
      workspace_id: 'workspaceId',
      workspace_name: 'workspaceName',
      created_by: 'createdBy',
      created_on: 'createdOn',
      updated_by: 'updatedBy',
      status: 'status',
      thumbnail_url: 'thumbnailUrl',
      title: 'title'
    )
  end
end
