#!/bin/bash

# Move files to the ../config directory
mv reducer.mpp ../config/reducer.mpp
mv mapper.mpp ../config/mapper.mpp
mv run-average.sh ../config/run-average.sh
mv generate.py ../config/generate.py

# Ensure the ../Dockerfile does not exist before moving
if [ -f "../Dockerfile" ]; then
  rm -rf ../Dockerfile
fi

# Move Dockerfile to the parent directory
mv Dockerfile ../Dockerfile
