VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  # Allows for things like: `context 'foo', vcr: true
  config.configure_rspec_metadata!

  # Make sure that we can communicate with code climate in semaphore
  config.ignore_hosts 'codeclimate.com'
end