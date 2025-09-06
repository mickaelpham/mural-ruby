# frozen_string_literal: true

module Mural
  class MuralInvitationParams
    include Mural::Codec

    # https://developers.mural.co/public/reference/inviteuserstomural
    define_attributes(
      edit_permission: 'editPermission',
      email: 'email',
      username: 'username'
    )
  end
end
