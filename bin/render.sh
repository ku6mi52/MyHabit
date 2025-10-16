#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
yarn build
yarn build:css --minify
bundle exec rake assets:clobber
bundle exec rake assets:precompile # cssはsprocketsを使っているため
bundle exec rake db:migrate        # cssはsprocketsを使っているため
