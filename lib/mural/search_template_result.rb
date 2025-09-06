# frozen_string_literal: true

module Mural
  class SearchTemplateResult
    include Mural::Codec

    # https://developers.mural.co/public/reference/searchtemplates
    define_attributes(
      id: 'id',
      workspace_id: 'workspaceId',
      created_on: 'createdOn',
      thumb_url: 'thumbUrl',
      view_link: 'viewLink',
      type: 'type',
      name: 'name'
    )
  end
end
