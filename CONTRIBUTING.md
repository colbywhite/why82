# Getting Started

### Install Postgres

```
# install
brew install postgres

# start
brew services start postgres
# if you're not using brew services, start postgres via the following
# postgres -D /usr/local/var/postgres

# create a dev db and user
createdb skeddev
createuser colby
```

See `config/database.yml` for what the db and user names should be in development.

### Install Rails

The easiest way to install ruby is through rvm. See [rvm.io](http://rvm.io) doc for installing rvm.
Once installed, install rails and the app dependencies via the following:

```bash
# install ruby
rvm install 2.2.0
rvm --default use 2.2.0

# install bundler
gem install bundler

# install app dependencies, including rails
bundle install --without production

# install bower globally for when you need it
npm install bower -g
```

## Setup DB

Once everything is installed there are a couple rake tasks to seed the database.

```bash
bundle exec rake db:migrate nba:seed:2016
```

`nba:seed:2016` takes a while to finish. See #31 as to why and the fix that is in the works.

# Extra Notes

## Code Style
Rubocop is used for code style. Make sure PRs follow conventions by 
running `bundle exec rubocop` before submission.

`bundle exec rubocop -a` will autocorrect errors if possible and is handy for small things.

Lint tools are needed for the frontend code.

## Issue Tracker
File any issues via [GitHub Issues](https://github.com/colbywhite/why82/issues).

## CI/CD
[Codeship](https://codeship.com/projects/99538) is used for build/deploy on every merged PR and pushed commit. `codeship-setup.rb`
and `codeship-test.rb` are what the CI runs.

Every pushed commit to `master` is deployed to why82.com.
