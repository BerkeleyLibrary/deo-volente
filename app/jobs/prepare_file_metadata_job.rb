class PrepareFileMetadataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Berkeley::DeoVolente::File.new(filename: fn)
    # returm metadata to whereer - as json?
  end
end
