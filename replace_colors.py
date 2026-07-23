import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    original = content

    content = content.replace("Colors.white54", "AppColors.white.withValues(alpha: 0.54)")
    content = content.replace("Colors.white70", "AppColors.white.withValues(alpha: 0.70)")
    content = content.replace("Colors.white", "AppColors.white")
    content = content.replace("Colors.black", "AppColors.black")
    content = content.replace("Colors.transparent", "AppColors.transparent")

    # Add NativeGlassNavBar tintColor in main_shell.dart if missing
    if 'main_shell.dart' in filepath:
        if 'tintColor:' not in content:
            content = content.replace(
                "fallback: Padding(",
                "tintColor: AppColors.accent,\n        fallback: Padding("
            )

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart') and 'app_theme.dart' not in file:
            process_file(os.path.join(root, file))
