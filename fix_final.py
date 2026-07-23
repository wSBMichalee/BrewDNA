import os

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    original = content
    
    if 'scan_screen.dart' in filepath:
        content = content.replace(
            "selectedIndex: _segmentedIndex,",
            "groupValue: _segmentedIndex,"
        ).replace(
            "onChanged: (val) => setState(() => _segmentedIndex = val),",
            "onValueChanged: (val) => setState(() => _segmentedIndex = val as int),"
        )
        
    if 'widget_gallery_screen.dart' in filepath:
        content = content.replace(
            "bottomNavigationBar: AppTabBar(",
            "// bottomNavigationBar: AppTabBar("
        ).replace(
            "currentIndex: 0,",
            "// currentIndex: 0,"
        ).replace(
            "onTap: (_) {},",
            "// onTap: (_) {},"
        ).replace(
            "items: [",
            "// items: ["
        ).replace(
            "BottomNavigationBarItem(icon: Icon(CupertinoIcons.camera), label: 'Skanuj'),",
            "// BottomNavigationBarItem(icon: Icon(CupertinoIcons.camera), label: 'Skanuj'),"
        ).replace(
            "BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), label: 'Moje Piwa'),",
            "// BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), label: 'Moje Piwa'),"
        )
        content = content.replace(
            "        ],\n      ),",
            "        // ],\n      // ),"
        )

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
