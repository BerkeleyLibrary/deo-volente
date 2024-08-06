# frozen_string_literal: true

require 'csv'
require 'digest'
require 'json'
require 'optparse'
require 'faraday'
require 'marcel'
require './util'

# Dataverse requires the following data for the add / addFiles endpoints
# for out-of-band uploads:
# * storage identifier - internal id (see generate_storageIdentifierentifier)
# * directory label - relative path to the file in the original directory
# * filename the filename without path info
# * a checksum in md5 (or another format)
# * mimetype
# * description
# Beyond this, we include the original filename and the directory where hard
# links will be located for the rsync job
HEADERS = %w[orig_filename link_directory storageIdentifier directoryLabel filename md5Hash mimeType description].freeze

DATAVERSE_URL = 'https://galt.lib.berkeley.edu'
MOUNTPOINT = '/usr/local/payara6/glassfish/domains/domain1/files'

def generate_manifest_row(orig_filename, basedir, tmpdir, doi)
  pn = Pathname.new(orig_filename)
  link_directory = Pathname.new(tmpdir) + doi
  storage_id = generate_storageIdentifierentifier
  directory_label, filename = pn.relative_path_from(basedir).split

  # we don't actually want to include the '.' reference to cwd
  directory_label = '' if directory_label.to_s == '.'
  checksum = Digest::MD5.file(orig_filename).hexdigest
  mimetype = Marcel::MimeType.for pn, name: filename
  [orig_filename, link_directory, storage_id, directory_label, filename, checksum, mimetype, '']
end

def generate_manifest(path, outfile, tmpdir, doi)
  CSV.open(outfile, 'w', write_headers: true, headers: HEADERS) do |csv|
    realpath = Pathname.new(path).realpath
    Pathname.glob(realpath + '**/*') do |p| # rubocop:disable Style/StringConcatenation
      csv << generate_manifest_row(p, realpath, tmpdir, doi) if p.file?
    end
  end
end

def link_for_rsync(filename, link_directory, storageIdentifier)
  linkname = Pathname.new(link_directory) + storageIdentifier
  File.link(filename, linkname)
end

def unlink_for_cleanup(link_directory, storageIdentifier)
  File.unlink(Pathname.new(link_directory) + storageIdentifier)
end

def rsync(tmpdir, flags: '-chavzrP')
  command = "rsync ${flags} ${tmpdir} ${MOUNTPOINT}"
  exec command
end

def _linkfiles(infile)
  data = CSV.open(infile, headers: true)
  data.each do |row|
    link_for_rsync(row['orig_filename'], row['link_directory'], row['storageIdentifier'])
  end
end

def add_files_from_csv(infile, api_key, doi)
  data = CSV.open(infile, headers: true) do 
  out = []
  # data.delete('orig_filename', 'link_directory')
  data.filter do |row|
    row.delete('orig_filename')
    row.delete('link_directory')
    row['storageIdentifier'] = "file://#{row['storageIdentifier']}"
    out << row.to_hash
  end
  out.to_json
end

def _post(data, api_key, doi)
  connection = Faraday.new(
    url: "#{DATAVERSE_URL}/api/datasets/:persistentId/addFiles?persistentId=#{doi}",
    headers: { 'X-Dataverse-key': api_key }
  )
  response = connection.post('post', jsonData: data)
  puts response
end

# def main
#   options = {}
#   OptionParser.new do |opts|
#     opts.banner = 'Usage: example.rb [options]'

#     opts.on('-doi', 'DOI of dataset to add files to') do |d|
#       options[:doi] = d
#     end

#     opts.on('-key', 'Dataverse API key') do |k|
#       options[:api_key] = k
#     end

#     opts.on('-server', 'Dataverse server URL') do |s|
#       options[:server] = s
#     end
#   end.parse!
# end

# main
