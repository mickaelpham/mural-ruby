# frozen_string_literal: true

module Mural
  class MuralUser
    include Mural::Codec

    # https://developers.mural.co/public/reference/getmuralusers
    define_attributes(
      id: 'id',
      email: 'email',
      avatar: 'avatar',
      first_name: 'firstName',
      last_name: 'lastName',
      type: 'type',
      permissions: 'permissions'
    )

    class Permissions
      include Mural::Codec

      define_attributes({ owner: 'owner', facilitator: 'facilitator' })
    end

    def self.decode(json)
      super.tap do |mural_user|
        mural_user.permissions = Permissions.decode(mural_user.permissions)
      end
    end
  end
end
