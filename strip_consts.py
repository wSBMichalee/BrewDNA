import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    original = content
    # Remove const before EdgeInsets
    content = re.sub(r'const\s+(EdgeInsets[^)]*AppSpacings[^)]*\))', r'\1', content)
    # Remove const before Text and Icon if they contain AppSpacings or AppTypography or AppColors (Wait, AppColors is still const)
    # Let's just remove const from EdgeInsets.all, EdgeInsets.symmetric, SizedBox, etc if they use AppSpacings/AppRadius
    content = re.sub(r'const\s+(EdgeInsets[^)]*AppSpacings.*?)\)', r'\1)', content, flags=re.DOTALL)
    content = re.sub(r'const\s+(SizedBox[^)]*AppSpacings.*?)\)', r'\1)', content, flags=re.DOTALL)
    
    # Text styles
    content = re.sub(r'const\s+(Text[^)]*AppTypography.*?)\)', r'\1)', content, flags=re.DOTALL)
    
    # AppRadius
    content = re.sub(r'const\s+(BorderRadius[^)]*AppRadius.*?)\)', r'\1)', content, flags=re.DOTALL)
    
    # Other const widgets with children
    # We might have `const Padding(...)` that contains AppSpacings.
    # It's safer to just remove all `const ` that precede widgets where the arguments contain AppSpacings, AppTypography, AppRadius
    
    # Just an iterative approach:
    # Any `const Word(` followed by anything before a `)` that contains AppSpacings, AppTypography, AppRadius
    # This might fail on nested parentheses. Let's do a simple string replacement for common ones:
    content = content.replace("const EdgeInsets.all(AppSpacings", "EdgeInsets.all(AppSpacings")
    content = content.replace("const EdgeInsets.symmetric(horizontal: AppSpacings", "EdgeInsets.symmetric(horizontal: AppSpacings")
    content = content.replace("const EdgeInsets.symmetric(vertical: AppSpacings", "EdgeInsets.symmetric(vertical: AppSpacings")
    content = content.replace("const EdgeInsets.only(bottom: AppSpacings", "EdgeInsets.only(bottom: AppSpacings")
    content = content.replace("const SizedBox(height: AppSpacings", "SizedBox(height: AppSpacings")
    content = content.replace("const SizedBox(width: AppSpacings", "SizedBox(width: AppSpacings")
    content = content.replace("const Text(", "Text(")
    
    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
