# frozen_string_literal: true

module Mural
  class CreateMuralParams
    include Mural::Codec

    define_attributes(
      title: 'title',
      room_id: 'roomId', # required
      # 👇 Rejected by the API (invalid "backgroundColor" property was sent)
      # background_color: 'backgroundColor',
      folder_id: 'folderId',
      height: 'height',
      infinite: 'infinite',
      width: 'width',
      visitors_settings: 'visitorsSettings',
      timer_sound_theme: 'timerSoundTheme',
      visitor_avatar_theme: 'visitorAvatarTheme'
    )

    def encode
      super.tap do |json|
        json['visitorsSettings'] = json['visitorsSettings']&.encode
      end
    end

    class VisitorsSettings
      include Mural::Codec

      define_attributes(expires_on: 'expiresOn')
    end
  end
end
