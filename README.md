[ ![Codeship Status for colbywhite/sked](https://codeship.com/projects/b9dbf740-2ff0-0133-67fb-468561e42530/status?branch=master)](https://codeship.com/projects/99538)

# why82

There are too many NBA games (1230 in total) and there's no way anybody can watch them all.
Instead, this project aims to narrow down the long schedule into the handful of games that are likely to be
worth your time.

More leagues/criteria will come in the future. 

The app is currently deployed to http://why82.com

## Build

```bash
# install dependencies
bundle install      # add "--without production" if you're building for dev
# clear db and reload seed data
bundle exec rake db:reseed 
```

## Tests

```bash
bundle exec rake spec
```

## Running locally

```bash
bundle exec rails s
```

## App Architecture

The back end is Rails while the front-end is angular. The angular js/coffee can
be found in `app/assets/javascripts` while the backend is mostly in `app`. 

The data is static sports data curated from various sources. The results are in 
`db/data`.

### bower
If you make bower changes via `Bowerfile`, be sure to run `bundle exec rake bower:install`. 
This will update `vendor/assets/bower_components` as needed.
