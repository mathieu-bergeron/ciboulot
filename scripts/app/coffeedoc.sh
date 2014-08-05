#!/bin/bash
pushd ../../app/coffee
coffeedoc-hub -o ../../docs/app/ *.coffee
popd
