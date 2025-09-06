# frozen_string_literal: true

module Mural
  class Client
    class Rooms
      extend Forwardable

      def_delegators :@client, :get, :post, :patch, :delete

      def initialize(client)
        @client = client
      end

      # https://developers.mural.co/public/reference/createroom
      def create(params)
        json = post('/api/public/v1/rooms', params.encode)

        Mural::Room.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/updateroombyid
      def update(room_id, params)
        json = patch("/api/public/v1/rooms/#{room_id}", params.encode)

        Mural::Room.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/deleteroombyid
      def destroy(room_id)
        delete("/api/public/v1/rooms/#{room_id}")
      end

      # https://developers.mural.co/public/reference/createroomfolder
      def create_folder(room_id, name:, parent_id: nil)
        json = post(
          "/api/public/v1/rooms/#{room_id}/folders",
          { name: name, parentId: parent_id }
        )

        ::Mural::RoomFolder.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/getroomfolders
      def list_folders(room_id, next_page: nil)
        json = get(
          "/api/public/v1/rooms/#{room_id}/folders",
          { next: next_page }
        )

        folders = json['value'].map do |json_folder|
          ::Mural::RoomFolder.decode(json_folder)
        end

        [folders, json['next']]
      end

      # https://developers.mural.co/public/reference/deleteroombyid
      def destroy_folder(room_id, folder_id)
        delete("/api/public/v1/rooms/#{room_id}/folders/#{folder_id}")
      end

      # https://developers.mural.co/public/reference/getroominfobyid
      def retrieve(room_id)
        json = get("/api/public/v1/rooms/#{room_id}")

        Mural::Room.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/getworkspacerooms
      def list(workspace_id, next_page: nil)
        json = get(
          "/api/public/v1/workspaces/#{workspace_id}/rooms",
          { next: next_page }
        )

        rooms = json['value'].map { |json_room| Mural::Room.decode(json_room) }
        [rooms, json['next']]
      end

      # https://developers.mural.co/public/reference/getworkspaceopenrooms
      def list_open(workspace_id, next_page: nil)
        json = get(
          "/api/public/v1/workspaces/#{workspace_id}/rooms/open",
          { next: next_page }
        )

        rooms = json['value'].map { |json_room| Mural::Room.decode(json_room) }
        [rooms, json['next']]
      end
    end
  end
end
