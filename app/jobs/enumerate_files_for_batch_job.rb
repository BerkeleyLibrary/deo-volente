class EnumerateFilesForBatchJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Batches
  queue_as :default

  @batch_size = 1000

  def perform(batch:, options:)
    return unless batch.properties[:stage].nil?

    batch.enqueue(stage: 1) do
      # jobs to
    end

    # CSV.open(outfile, 'w', write_headers: true, headers: HEADERS) do |csv|
    #   realpath = Pathname.new(path).realpath
    #   Pathname.glob(realpath + '**/*') do |p|
    #     csv << generate_manifest_row(p, realpath, tmpdir, doi) if p.file?
    #   end
    # end
    # end
  end
end
