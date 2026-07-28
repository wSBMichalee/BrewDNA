#!/bin/bash
mkdir -p ~/Desktop/brewdna-screens

echo "Starting Flutter Integration Test for Screenshots..."
flutter test integration_test/screenshot_test.dart -d B64A4E69-8976-49A6-B97A-6663BAEEE58B | while read -r line; do
  echo "$line"
  if [[ "$line" == *"SCREENSHOT_READY:"* ]]; then
    NAME=$(echo "$line" | sed 's/.*SCREENSHOT_READY: //')
    echo "Host: Taking screenshot for $NAME..."
    xcrun simctl io booted screenshot ~/Desktop/brewdna-screens/${NAME}.png
  fi
  if [[ "$line" == *"SCREENSHOTS_DONE"* ]]; then
    echo "Host: Finished taking automated screenshots."
  fi
done
