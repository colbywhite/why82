#!/usr/bin/env bash

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
rvm use 2.2.0 --install
set -e
set -x

bundle install --without production
# codeship overrides the database.yml to use postgres.
# This will set it back to the one in git
# See: https://codeship.com/documentation/databases/postgresql/#ruby-on-rails
git checkout config/database.yml