Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1516230728630497', 'b5cab04a31993547c3ad19282f309fb1', scope: 'public_profile,read_stream,user_friends'
  provider :instagram, 'f5c2ab0447324f05b11f2b52dfd1da78', '688f123556084479a97cb6b605cdd815'
  provider :twitter, '3qTH5woXpYBQeOWwIFFimyrQa', 'TU4u1Y7DENtuJfszTsuPgU4ljXFV2gnd6TLyRCNM1RYFkBbtP3'
  provider :pinterest, '1441389', 'a6b3c1d5'
end