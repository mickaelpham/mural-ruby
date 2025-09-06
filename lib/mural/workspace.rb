# frozen_string_literal: true

module Mural
  class Workspace
    include Mural::Codec

    # https://developers.mural.co/public/reference/getworkspaces
    # https://developers.mural.co/public/reference/getworkspace
    define_attributes(
      id: 'id',
      name: 'name',
      description: 'description',
      sharing_settings: 'sharingSettings',
      locked: 'locked',
      suspended: 'suspended',
      company_id: 'companyId',
      created_on: 'createdOn',
      trial_ends: 'trialEnds',
      trial_extended: 'trialExtended',
      # 👇 Only available when retrieving a single workspace
      created_by: 'createdBy'
    )

    def self.decode(json)
      super.tap do |w|
        w.created_by = CreatedBy.decode(w.created_by)
        w.sharing_settings = SharingSettings.decode(w.sharing_settings)
      end
    end

    class SharingSettings
      include Mural::Codec

      define_attributes(link: 'link')
    end

    class CreatedBy
      include Mural::Codec

      define_attributes(
        id: 'id',
        first_name: 'firstName',
        last_name: 'lastName'
      )
    end
  end
end
