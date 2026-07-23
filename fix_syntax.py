import os

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    original = content
    
    if 'widget_test.dart' in filepath:
        content = content.replace("const HopIqApp()", "HopIqApp()")
        
    if 'widget_gallery_screen.dart' in filepath:
        content = content.replace("        // ],\n      // ),", "      //  ],\n      // ),")
        # Let's just fix it by replacing the whole commented block with nothing, it's just a dev screen.
        content = content.replace("// bottomNavigationBar: AppTabBar(\n// currentIndex: 0,\n// onTap: (_) {},\n// items: [\n// BottomNavigationBarItem(icon: Icon(CupertinoIcons.camera), label: 'Skanuj'),\n// BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), label: 'Moje Piwa'),\n        // ],\n      // ),", "")

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
            
for root, _, files in os.walk('test'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
