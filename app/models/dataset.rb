# frozen_string_literal: true

require 'activeresource'

module DataverseResponseJsonFormat
  include ActiveResource::Formats::JsonFormat

  extend self

  def decode(json)
    ActiveSupport::JSON.decode(json)['data']
  end
end

# A representation of a Dataverse Dataset (backed by ActiveResource)
class Dataset < ActiveResource::Base
  self.format = DataverseResponseJsonFormat
  # TODO: extract this into configuration
  self.site = 'https://datasets.lib.berkeley.edu/api/'
  headers['X-Dataverse-key'] = 'something'
  self.include_format_in_path = false

  has_many :versions

  def self.find_by_pid(pid)
    find(:one, from: :':persistentId', params: { persistentId: pid })
  end

  # def self.all
  #   find(:all, from: "#{site}/dataverses/licensed_data/contents")
  # end
end
