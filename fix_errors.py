import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    original = content
    
    # 1. Fix AppButtonType
    content = content.replace("type: AppButtonType.secondary,", "isPrimary: false,")
    content = content.replace("type: AppButtonType.primary,", "isPrimary: true,")
    
    # 2. Fix AppSegmentedControl in history_screen
    if 'history_screen.dart' in filepath:
        content = content.replace(
            "labels: const ['Oceny', 'Wishlista', 'Piwniczka', 'Historia'],",
            "items: const {0: 'Oceny', 1: 'Wishlista', 2: 'Piwniczka', 3: 'Historia'},"
        ).replace(
            "selectedIndex: _segmentedIndex,",
            "groupValue: _segmentedIndex,"
        ).replace(
            "onChanged: (val) => setState(() => _segmentedIndex = val),",
            "onValueChanged: (val) => setState(() => _segmentedIndex = val as int),"
        )
        
    # 3. Fix AppSegmentedControl in scan_screen
    if 'scan_screen.dart' in filepath:
        content = content.replace(
            "labels: const ['Etykieta', 'Lista'],",
            "items: const {0: 'Etykieta', 1: 'Lista'},"
        ).replace(
            "selectedIndex: _scanModeIndex,",
            "groupValue: _scanModeIndex,"
        ).replace(
            "onChanged: (val) => setState(() => _scanModeIndex = val),",
            "onValueChanged: (val) => setState(() => _scanModeIndex = val as int),"
        )
        
    # 4. Fix AppSpacings.s64 if any (intro_screen.dart)
    content = content.replace("AppSpacings.s64", "64.0.h")
    
    # 5. Fix CupertinoIcons.applelogo
    content = content.replace("CupertinoIcons.applelogo", "Icons.apple")
    if 'auth_start_screen.dart' in filepath and 'CupertinoIcons.applelogo' in original:
        if 'import \'package:flutter/material.dart\';' not in content:
            content = "import 'package:flutter/material.dart';\n" + content
            
    # 6. Fix CupertinoIcons.leaf_fill (doesn't exist, use leaf)
    content = content.replace("CupertinoIcons.leaf_fill", "CupertinoIcons.leaf_arrow_circlepath") # just leaf is fine, let's use leaf. Wait, leaf doesn't exist?
    content = content.replace("CupertinoIcons.leaf_fill", "Icons.eco") # Let's use Icons.eco for leaf.
    if 'onboarding_screen.dart' in filepath and 'Icons.eco' in content:
        if 'import \'package:flutter/material.dart\';' not in content:
            content = "import 'package:flutter/material.dart';\n" + content
    
    # 7. i_beer_repository.dart import
    if 'i_beer_repository.dart' in filepath:
        content = content.replace("import 'beer.dart';", "import '../entities/beer.dart';")
        
    # 8. test/widget_test.dart
    if 'widget_test.dart' in filepath:
        content = content.replace("const MyApp()", "const HopIqApp()")

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
for root, _, files in os.walk('test'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
