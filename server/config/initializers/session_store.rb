# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_CrackCheckServer_session',
  :secret      => 'c3111d3637b4bc6751d28e49052c7b4b7b6c93b2fa55a5493ccd40e3e1fd4ca72f124d2466be4a2d1b5029504c72d27cb80bd871d818e24414b6b27cc3e1978a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
