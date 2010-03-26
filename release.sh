#!/bin/sh
v="$1"
git archive --format=zip --prefix=openzoom/ HEAD > openzoom-sdk-$v.zip
