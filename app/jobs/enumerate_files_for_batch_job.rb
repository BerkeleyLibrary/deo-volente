class EnumerateFilesForBatchJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # CSV.open(outfile, 'w', write_headers: true, headers: HEADERS) do |csv|
    #   realpath = Pathname.new(path).realpath
    #   Pathname.glob(realpath + '**/*') do |p| # rubocop:disable Style/StringConcatenation
    #     csv << generate_manifest_row(p, realpath, tmpdir, doi) if p.file?
    #   end
    # end
    end
  end
end
