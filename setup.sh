#!/bin/bash

# Move files to the ../config directory
mv ./reducer.cpp ../config/reducer.cpp
mv ./mapper.cpp ../config/mapper.cpp
mv ./run-average.sh ../config/run-average.sh
mv ./generate.py ../config/generate.py

# Ensure the ../Dockerfile does not exist before moving
if [ -f "../Dockerfile" ]; then
  rm -rf ../Dockerfile
fi

# Move Dockerfile to the parent directory
mv Dockerfile ../Dockerfile
