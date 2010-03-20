#!/bin/sh
v="$1"
git archive --format=zip --prefix=openzoom-sdk/ HEAD > openzoom-sdk-$v.zip
