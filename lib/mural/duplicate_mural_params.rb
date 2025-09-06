# frozen_string_literal: true

module Mural
  class DuplicateMuralParams
    include Mural::Codec

    define_attributes(
      room_id: 'roomId',
      folder_id: 'folderId',
      infinite: 'infinite',
      title: 'title'
    )
  end
end
