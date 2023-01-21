#!/usr/bin/env bash

BUCKET=s3://my-bucket.com ## TODO

echo "Building Elm Assets..."
./build.sh

## echo "Building Sass Assets"
## cd web/sass && (npm run build)
## cd ..
##
## echo "Building JS Assets"
## cd js && (npm run build)
## cd ../..

echo "Publishing New Assets..."
## aws s3 sync web/images/ $BUCKET/images/ --profile tap-in
aws s3 cp web/index.html $BUCKET --profile tap-in
aws s3 cp web/elm.min.js $BUCKET --profile tap-in
aws s3 cp web/css/ $BUCKET/css/ --recursive --profile tap-in
## aws s3 cp web/js/bundle.js $BUCKET/js/ --profile tap-in

## echo "Invalidating CloudFront Cache..." TODO
## aws cloudfront create-invalidation --distribution-id E1G8ZLLJOSOIW8 --paths "/*" --profile tap-in
