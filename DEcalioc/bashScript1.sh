#!/bin/bash

# create calibration directory
cd ~
mkdir -p calibration

# create calibration sub-folder using the current date and time
cd calibration/
mkdir $(date +%Y%m%d_%H%M%S)
ls -t