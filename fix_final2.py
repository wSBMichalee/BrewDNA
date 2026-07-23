import os

filepath = 'lib/features/dev/presentation/screens/widget_gallery_screen.dart'
with open(filepath, 'r') as f:
    content = f.read()

content = content.replace(
    "          )),\n        ],\n      ),\n    );",
    "          )),\n        ],\n      ),\n    );\n  }"
)

# Removing extra closing brace if any
content = content.replace("    );\n  }\n\n  Widget _buildSection", "    );\n\n  Widget _buildSection")

with open(filepath, 'w') as f:
    f.write(content)
