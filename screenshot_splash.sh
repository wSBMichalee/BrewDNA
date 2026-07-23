#!/bin/bash
sleep 2.5 # Wait for hot restart to compile and sync
xcrun simctl io booted screenshot splash_05.png
sleep 1.0
xcrun simctl io booted screenshot splash_15.png
sleep 1.0
xcrun simctl io booted screenshot splash_25.png
