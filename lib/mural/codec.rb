# frozen_string_literal: true

module Mural
  # Utility module to convert from lowerCamelCase JSON to Ruby classes with
  # proper accessors (using snake_case) and vice versa when building a payload
  # to Mural.
  module Codec
    def encode
      {}.tap do |json|
        self.class.attrs.each do |attr, remote_attr|
          value = public_send(attr)

          json[remote_attr] = value unless value.nil?
        end
      end
    end

    module ClassMethods
      def attrs
        @attrs ||= {}
      end

      def define_attributes(values)
        @attrs = values.freeze

        attrs.each_key { |attr| attr_accessor(attr) }
      end

      def decode(json)
        return if json.nil?

        new.tap do |instance|
          attrs.each do |attr, remote_attr|
            instance.public_send(:"#{attr}=", json[remote_attr])
          end
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
