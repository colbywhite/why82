# If working locally, these are the env vars needed in the .env file:
#   - PORT
#   - RAILS_ENV

web: bin/rails server -p $PORT -e $RAILS_ENV
worker: bundle exec rake jobs:work