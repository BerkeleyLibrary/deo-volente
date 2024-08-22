class UploadFileToDataverseJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # connection = Faraday.new(
    #   url: "#{DATAVERSE_URL}/api/datasets/:persistentId/addFiles?persistentId=#{doi}",
    #   headers: { 'X-Dataverse-key': api_key }
    # )
    # response = connection.post('post', jsonData: data)
    # puts response
  end
end
