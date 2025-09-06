# frozen_string_literal: true

module Mural
  class UpdateMuralParams
    include Mural::Codec

    # https://developers.mural.co/public/reference/updatemuralbyid
    define_attributes(
      background_color: 'backgroundColor',
      favorite: 'favorite',
      folderId: 'folderId',
      height: 'height',
      infinite: 'infinite',
      width: 'width',
      title: 'title',
      status: 'status',
      timer_sound_theme: 'timerSoundTheme',
      visitor_avatar_theme: 'visitorAvatarTheme',
      visitors_permission: 'visitorsPermission',
      workspace_members_permission: 'workspaceMembersPermission'
    )
  end
end
