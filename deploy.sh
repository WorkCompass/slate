#!/usr/bin/env bash

bundle exec middleman build --clean
cp -r build/* ~/projects/cognito/public/docs/
mv ~/projects/cognito/public/docs/index.html ~/projects/cognito/public/docs/api/

