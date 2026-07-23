import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    original = content

    # Add imports
    if 'import \'package:flutter_screenutil/flutter_screenutil.dart\';' not in content:
        if 'package:flutter/material.dart' in content or 'package:flutter/cupertino.dart' in content:
            content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_screenutil/flutter_screenutil.dart';")
            if 'import \'package:flutter_screenutil/flutter_screenutil.dart\';' not in content:
                 content = content.replace("import 'package:flutter/cupertino.dart';", "import 'package:flutter/cupertino.dart';\nimport 'package:flutter_screenutil/flutter_screenutil.dart';")

    # Fix const Padding, const SizedBox, const Text, const Column, const Row, const Center
    # We will remove ALL `const ` that precede widgets, it's safer for this quick fix because flutter analyze will only warn about missing const, not error (mostly).
    # Actually removing all consts before capitalized words:
    content = re.sub(r'const\s+([A-Z]\w*\(|\[)', r'\1', content)

    # Fix specific errors
    content = content.replace("DialogTheme(", "DialogThemeData(")
    if 'app_theme.dart' in filepath:
        if "import 'package:flutter/cupertino.dart';" not in content:
            content = "import 'package:flutter/cupertino.dart';\n" + content
            
    if 'app_card.dart' in filepath:
        content = content.replace("this.padding = EdgeInsets.all(AppSpacings.s16),", "this.padding,")
        content = content.replace("padding: padding,", "padding: padding ?? EdgeInsets.all(AppSpacings.s16),")

    if 'scan_screen.dart' in filepath:
        content = content.replace(
            "labels: ['Etykieta', 'Lista'],",
            "items: {0: 'Etykieta', 1: 'Lista'},"
        ).replace(
            "selectedIndex: _scanModeIndex,",
            "groupValue: _scanModeIndex,"
        ).replace(
            "onChanged: (val) => setState(() => _scanModeIndex = val),",
            "onValueChanged: (val) => setState(() => _scanModeIndex = val as int),"
        )
        
    if 'widget_gallery_screen.dart' in filepath:
        content = content.replace(
            "labels: ['Opcja 1', 'Opcja 2', 'Opcja 3'],",
            "items: {0: 'Opcja 1', 1: 'Opcja 2', 2: 'Opcja 3'},"
        ).replace(
            "selectedIndex: 0,",
            "groupValue: 0,"
        ).replace(
            "onChanged: (v) {},",
            "onValueChanged: (v) {},"
        )
        
    if 'app_router.dart' in filepath:
        # AppRouter had some duplicate imports and bracket errors. Let's not touch brackets with regex, I'll fix manually.
        pass

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
            
