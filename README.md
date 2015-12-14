[ ![Codeship Status for colbywhite/sked](https://codeship.com/projects/b9dbf740-2ff0-0133-67fb-468561e42530/status?branch=master)](https://codeship.com/projects/99538)

# why82

There are too many NBA games (1230 in total) and there's no way anybody can watch them all.
Instead, this project aims to narrow down the long schedule into the handful of games that are likely to be
worth your time.

More leagues/criteria will come in the future. 

The app is currently deployed to http://why82.com

## Contributing and Running Locally

See `CONTRIBUTING.md` for info on how to run the app locally.

## App Architecture

The back end is Rails while the front-end is angular. The angular js/coffee can
be found in `app/assets/javascripts` while the backend is mostly in `app`.
 
Game results are retrieved from basketballreference via a `rake nba:seed:YEAR` command. 
