class CopyFileToDataverseStorageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # copy to storage location and optionally check md5?
  end
end
