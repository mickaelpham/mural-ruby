# frozen_string_literal: true

module Mural
  class Room
    include Mural::Codec

    # https://developers.mural.co/public/reference/getroominfobyid
    define_attributes(
      id: 'id',
      name: 'name',
      description: 'description',
      favorite: 'favorite',
      created_by: 'createdBy',
      created_on: 'createdOn',
      updated_by: 'updatedBy',
      updated_on: 'updatedOn',
      type: 'type',
      confidential: 'confidential',
      workspace_id: 'workspaceId',
      # 👇 Only visible when the logged in user is an admin ("owner" in Mural
      #    terminology) of the room. Not returned on creation.
      sharing_settings: 'sharingSettings'
    )

    def self.decode(json)
      super.tap do |room|
        room.created_by = CreatedBy.decode(room.created_by)
        room.updated_by = CreatedBy.decode(room.updated_by)
        room.sharing_settings = SharingSettings.decode(room.sharing_settings)
      end
    end

    class CreatedBy
      include Mural::Codec

      define_attributes(
        {
          first_name: 'firstName',
          id: 'id',
          last_name: 'lastName'
        }
      )
    end

    class UpdatedBy
      include Mural::Codec

      define_attributes(
        {
          first_name: 'firstName',
          id: 'id',
          last_name: 'lastName'
        }
      )
    end

    class SharingSettings
      include Mural::Codec

      define_attributes({ link: 'link' })
    end
  end
end
