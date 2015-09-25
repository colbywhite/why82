[ ![Codeship Status for colbywhite/sked](https://codeship.com/projects/b9dbf740-2ff0-0133-67fb-468561e42530/status?branch=master)](https://codeship.com/projects/99538)

# sked web app

This is an in-progress web app with the goal of filtering down a sports schedule
based on criteria. For the first pass, it is NBA focused and the criteria is 
given by the user in the form of what teams they are interested in. 

More leagues/criteria will come in the future. 

The app is currently deployed as a free heroku app via 
https://damp-badlands-4590.herokuapp.com. Free heroku apps 
go to sleep when not in use. 

## Build

```bash
# install dependencies
bundle install      # add "--without production" if you're building for dev
# clear db and reload seed data
bundle exec rake db:reseed 
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

## TODO
- come up with a better name than sked!

