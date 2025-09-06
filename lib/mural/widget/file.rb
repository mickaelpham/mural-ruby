# frozen_string_literal: true

module Mural
  class Widget
    class File
      include Mural::Codec

      # https://developers.mural.co/public/reference/createfile
      define_attributes(
        **Mural::Widget.attrs,

        # The number of minutes after which the file URL expires.
        # May be null when download restriction is enabled.
        expires_in_minutes: 'expiresInMinutes',

        # The link to the file widget on a mural.
        link: 'link',

        # The download URL of the file. This URL has expiration time.
        # May be null when download restriction is enabled.
        url: 'url',

        # Indicates that file was scanned by antivirus.
        scanning: 'scanning',

        # The URL of the file preview.
        preview_url: 'previewUrl',

        # The title of the widget in the outline.
        title: 'title'
      )
    end
  end
end
