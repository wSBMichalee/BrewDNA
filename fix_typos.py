import os

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    original = content

    content = content.replace("AppColors.black87", "AppColors.black.withValues(alpha: 0.87)")
    content = content.replace("AppColors.black12", "AppColors.black.withValues(alpha: 0.12)")
    content = content.replace("AppColors.black26", "AppColors.black.withValues(alpha: 0.26)")
    content = content.replace("AppAppColors", "AppColors")

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
