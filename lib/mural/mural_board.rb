# frozen_string_literal: true

module Mural
  # Mural, the company, is also calling their main document a "mural" in lower
  # case. Unfortunately, this doesn't translate well to a programming language
  # and I'd rather have a #<Mural::MuralBoard> instance instead of a
  # #<Mural::Mural> one, the repetition is driving me insane. And it's also
  # what their main competitor (Miro) is calling the document, so it's not to
  # far-fetched. I also believe that historically, a "mural" (the document) used
  # to be called a board as well within Mural (the company/product).
  class MuralBoard
    include Mural::Codec

    # https://developers.mural.co/public/reference/getmuralbyid
    define_attributes(
      background_color: 'backgroundColor',
      created_by: 'createdBy',
      created_on: 'createdOn',
      embed_link: 'embedLink',
      favorite: 'favorite',
      folder_id: 'folderId',
      height: 'height',
      id: 'id',
      infinite: 'infinite',
      room_id: 'roomId',
      sharing_settings: 'sharingSettings',
      state: 'state',
      status: 'status',
      thumbnail_url: 'thumbnailUrl',
      timer_sound_theme: 'timerSoundTheme',
      title: 'title',
      updated_by: 'updatedBy',
      updated_on: 'updatedOn',
      visitor_avatar_theme: 'visitorAvatarTheme',
      visitors_settings: 'visitorsSettings', # spelling is on Mural side
      width: 'width',
      workspace_id: 'workspaceId'
    )

    def self.decode(json)
      super.tap do |mural|
        mural.created_by = CreatedBy.decode(mural.created_by)
        mural.updated_by = UpdatedBy.decode(mural.updated_by)
        mural.sharing_settings = SharingSettings.decode(mural.sharing_settings)
        mural.visitors_settings =
          VisitorsSettings.decode(mural.visitors_settings)
      end
    end

    class AccessInformation
      include Mural::Codec

      define_attributes(
        visitors: 'visitors',
        workspace_members: 'workspaceMembers'
      )
    end

    class CreatedBy
      include Mural::Codec

      define_attributes(
        first_name: 'firstName',
        id: 'id',
        last_name: 'lastName'
      )
    end

    class UpdatedBy
      include Mural::Codec

      define_attributes(
        first_name: 'firstName',
        id: 'id',
        last_name: 'lastName'
      )
    end

    class SharingSettings
      include Mural::Codec

      define_attributes(link: 'link')
    end

    class VisitorsSettings
      include Mural::Codec

      define_attributes(
        visitors: 'visitors',
        workspace_members: 'workspaceMembers',
        link: 'link',
        expires_on: 'expiresOn'
      )
    end
  end
end
