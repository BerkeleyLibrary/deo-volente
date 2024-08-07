# frozen_string_literal: true

require 'date'
require 'digest'
require 'json'
require 'pathname'
require 'securerandom'
require 'marcel'

module BerkeleyLibrary
  module DeoVolente
    # Abstraction for interacting with files using the Dataverse API
    class File
      attr_accessor :filename, :realpath, :directory_label, :description, :dataverse_id, :restrict,
                    :force_replace, :checksum
      attr_writer :storage_identifier, :md5_hash, :mime_type

      def initialize(filename:, md5_hash: nil, mime_type: nil, directory_label: nil,
                     storage_identifier: BerkeleyLibrary::DeoVolente::File.generate_storage_identifier)
        pn = Pathname.new(filename)
        @filename = pn.basename.to_s
        @realpath = pn.realpath
        @directory_label = directory_label if directory_label
        @storage_identifier = storage_identifier
        @md5_hash = md5_hash if md5_hash
        @mime_type = mime_type if mime_type
      end

      def md5_hash
        @md5_hash ||= Digest::MD5.file(@realpath).hexdigest
      end

      def mime_type
        @mime_type ||= Marcel::MimeType.for @realpath, name: @filename
      end

      def storage_identifier
        @storage_identifier ||= BerkeleyLibrary::DeoVolente::File.generate_storage_identifier
      end

      def to_hash
        h = {}
        instance_variables.each { |v| h[v.to_s.delete('@')] = instance_variable_get(v) }
        h
      end

      def to_json(*_args)
        j = {}
        j[:directoryLabel] = @directory_label if @directory_label
        j[:md5Hash] = md5_hash
        j[:mimeType] = mime_type
        j[:storageIdentifier] = BerkeleyLibrary::DeoVolente::File.generate_storage_uri(@storage_identifier)
        j[:fileName] = @filename
        j[:description] = @description || ''
        j[:dataverseId] = @dataverse_id if @dataverse_id
        # j[:restrict] - boolean
        # j[:forceReplace] - boolean
        # j[:checksum] - {'@type': String, '@value': String}
        j.to_json
      end

      def self.get_directory_label(filename:, basedir:)
        directory_label, _fn = Pathname.new(filename).relative_path_from(basedir).split
        directory_label
      end

      # equivalent to e.h.i.dataverse.util.FileUtil.generateStorageIdentifier
      # n.b. this does not include the protocol/driver and separator
      def self.generate_storage_identifier
        uuid = SecureRandom.uuid
        # last 6 bytes of the random uuid in hex
        hex_random = uuid[24..]

        # get milliseconds since epoch, and convert to hex digits
        timestamp = DateTime.now
        hex_timestamp = timestamp.strftime('%Q').to_i.to_s(16)

        "#{hex_timestamp}-#{hex_random}"
      end

      def self.generate_storage_uri(identifier, driver: 'file', separator: '://')
        "#{driver}#{separator}#{identifier}"
      end
    end
  end
end
