# frozen_string_literal: true

module Mural
  class RoomFolder
    include Mural::Codec

    # https://developers.mural.co/public/reference/getroomfolders
    define_attributes(
      children: 'children',
      id: 'id',
      name: 'name'
    )

    def self.decode(json)
      super.tap do |folder|
        # Recursively map out the children
        folder.children&.map! { |child| decode(child) }
      end
    end
  end
end
