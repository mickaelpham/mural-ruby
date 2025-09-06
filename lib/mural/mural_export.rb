# frozen_string_literal: true

module Mural
  class MuralExport
    include Mural::Codec

    # https://developers.mural.co/public/reference/exporturlmural
    define_attributes(
      created_on: 'createdOn',
      expire_on: 'expireOn',
      export_id: 'exportId',
      mural_id: 'muralId',
      url: 'url'
    )
  end
end
