# frozen_string_literal: true

require 'spec_helper'

module BerkeleyLibrary
  # A set of helper tools for loading data into the UC Berkeley Dataverse
  module DeoVolente
    describe File do
      let(:orig_filename) { 'spec/data/foo.csv' }

      context 'with an instance' do
        let(:file_instance) { described_class.new(filename: orig_filename) }
        let(:fi_filename) { 'foo.csv' }
        let(:fi_mime_type) { 'text/csv' }
        let(:fi_md5) { '11f8e9dc8c473278962dbadfd803e4c1' }

        describe '#initialize' do
          it 'creates a new instance' do
            expect(file_instance.filename).to eq(fi_filename)
          end

          it 'creates a new instance with fully specified options' do
            f = described_class.new(filename: 'spec/data/unrecognizable', md5_hash: 'md5', directory_label: 'bogus',
                                    mime_type: 'application/json', storage_identifier: 'not_Real')
            expect(f).to have_attributes(md5_hash: 'md5', directory_label: 'bogus', mime_type: 'application/json',
                                         storage_identifier: 'not_Real')
          end
        end

        describe '#md5_hash' do
          it 'calculates an MD5' do
            expect(file_instance.md5_hash).to eq(fi_md5)
          end
        end

        describe '#mime_type' do
          it 'gets the MIME type' do
            expect(file_instance.mime_type).to eq(fi_mime_type)
          end

          it 'gets a default MIME type when it exhausts Marcel criteria' do
            f = described_class.new(filename: 'spec/data/unrecognizable')
            expect(f.mime_type).to eq('application/octet-stream')
          end
        end

        context 'when calling serialization methods' do
          before do
            file_instance.mime_type
            file_instance.md5_hash
          end

          describe '#to_h' do
            it 'returns a hash' do
              h = file_instance.to_h
              expect(h).to include(filename: fi_filename, mime_type: fi_mime_type, md5_hash: fi_md5)
            end
          end

          describe '#to_json' do
            it 'returns a JSON object suitable for Dataverse' do
              parsed = JSON.parse(file_instance.to_json)
              expect(parsed).to include('md5Hash' => fi_md5, 'description' => '', 'fileName' => fi_filename,
                                        'mimeType' => fi_mime_type, 'storageIdentifier' => match(%r{^file://}))
            end
          end
        end
      end

      context 'when calling class methods' do
        describe '::get_directory_label' do
          let(:dir) { '/srv/bigdata' }

          it 'returns a directory label for Dataverse' do
            dl = described_class.get_directory_label(filename: "#{dir}/#{orig_filename}", basedir: "#{dir}/spec")
            expect(dl).to eq('data')
          end
        end

        context 'with storage identifier methods' do
          let(:id) { described_class.generate_storage_identifier }

          describe '::generate_storage_identifier' do
            it 'returns a valid storage identifier' do
              s = described_class.generate_storage_identifier
              # since the first part of the Dataverse storage identifier is based
              # on ms since epoch, it may (as of 2024-08) end up being longer
              # than 10 hexadecimal digits (:trollface:)
              expect(s).to match(/^[\da-f]{10,}-[\da-f]{12}$/)
            end
          end

          describe '::generate_storage_uri' do
            it 'generates a default (file) storage identifier' do
              uri = described_class.generate_storage_uri(id)
              expect(uri).to eq("file://#{id}")
            end

            it 'generates a storage identifier with additional parameters' do
              uri = described_class.generate_storage_uri(id, driver: 's3',
                                                             prefix: 'oskis_bucket', prefix_separator: ':')
              expect(uri).to eq("s3://oskis_bucket:#{id}")
            end
          end
        end
      end
    end
  end
end
