# frozen_string_literal: true

module Mural
  class CurrentUser
    include Mural::Codec

    # https://developers.mural.co/public/reference/getcurrentmember
    define_attributes(
      id: 'id',
      email: 'email',
      avatar: 'avatar',
      first_name: 'firstName',
      last_name: 'lastName',
      created_on: 'createdOn',
      company_id: 'companyId',
      company_name: 'companyName',
      type: 'type',
      last_active_workspace: 'lastActiveWorkspace'
    )
  end
end
