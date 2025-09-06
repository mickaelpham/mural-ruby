# frozen_string_literal: true

module Mural
  class Template
    include Mural::Codec

    # https://developers.mural.co/public/reference/getdefaulttemplates
    define_attributes(
      id: 'id',
      name: 'name',
      description: 'description',
      created_on: 'createdOn',
      created_by: 'createdBy',
      updated_on: 'updatedOn',
      updated_by: 'updatedBy',
      type: 'type',
      workspace_id: 'workspaceId',
      thumb_url: 'thumbUrl',
      view_link: 'viewLink',
      # 👇 only returned when creating a custom template
      mural_id: 'muralId'
    )
  end
end
