with open('lib/features/main/presentation/screens/profile_screen.dart', 'r') as f:
    lines = f.readlines()

out = []
in_header = False
for line in lines:
    if 'Widget _buildBrandedHeader(BuildContext context, UserTasteStats stats) {' in line:
        in_header = True
        continue
    if in_header and '  Widget _buildTasteProfileCircles() {' in line:
        in_header = False
    
    if in_header:
        continue
    
    if 'return _buildBrandedHeader(context, stats);' in line:
        out.append(line.replace('return _buildBrandedHeader(context, stats);', 'return BrandedProfileHeader(stats: stats);'))
        continue
        
    out.append(line)

with open('lib/features/main/presentation/screens/profile_screen.dart', 'w') as f:
    f.writelines(out)
