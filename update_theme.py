import os

filepath = 'lib/core/theme/app_theme.dart'
with open(filepath, 'r') as f:
    content = f.read()

replacement = """  static const Color card = Color(0xFFF2F2F7); // Added based on typical usage
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
"""

content = content.replace("  static const Color card = Color(0xFFF2F2F7); // Added based on typical usage\n", replacement)

with open(filepath, 'w') as f:
    f.write(content)
