require "date"
require "securerandom"

# equivalent to e.h.i.dataverse.util.FileUtil.generateStorageIdentifier
def generate_storage_identifier
  uuid = SecureRandom.uuid
  # last 6 bytes of the random uuid in hex
  hex_random = uuid[24..]

  # get milliseconds since epoch, and convert to hex digits
  timestamp = DateTime.now
  hex_timestamp = timestamp.strftime('%Q').to_i.to_s(16)
  
  return "file://#{hex_timestamp}-#{hex_random}"
end