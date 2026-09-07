import re

with open('lib/features/main/presentation/screens/profile_screen.dart', 'r') as f:
    content = f.read()

# Add imports
imports = """import '../widgets/branded_profile_header.dart';
import '../widgets/taste_profile_circles.dart';
import '../widgets/taste_profile_editor_sheet.dart';
import '../widgets/achievements_section.dart';
import '../widgets/profile_menu_section.dart';
"""
content = re.sub(r"(import 'package:flutter/cupertino\.dart';)", r"\1\n" + imports, content, count=1)

# 1. Replace _buildBrandedHeader call
content = re.sub(r"return _buildBrandedHeader\(context, stats\);", r"return BrandedProfileHeader(stats: stats);", content)

# 2. Replace _buildTasteProfileCircles call
content = re.sub(r"_buildTasteProfileCircles\(\),", r"""TasteProfileCircles(
      isLoading: _isLoadingTasteProfile,
      profile: _tasteProfile,
      onEditTap: () => _showEditTasteProfileSheet(_tasteProfile ?? const TasteProfile()),
    ),""", content)

# 3. Replace _TasteProfileEditorSheet call
content = re.sub(r"return _TasteProfileEditorSheet\(", r"return TasteProfileEditorSheet(", content)

# 4. Replace Achievements Section
achievements_pattern = r"// 2\. Osiągnięcia \(Placeholder\).*?SizedBox\(height: AppSpacings\.s32\),"
content = re.sub(achievements_pattern, r"const AchievementsSection(),\n              SizedBox(height: AppSpacings.s32),", content, flags=re.DOTALL)

# 5. Replace _buildMenuSection call
content = re.sub(r"_buildMenuSection\(context\),", r"ProfileMenuSection(\n                onShareTap: () => _openShareCardSheet(context),\n              ),", content)


# Remove definitions

# Remove _buildBrandedHeader
content = re.sub(r"  Widget _buildBrandedHeader\(.*?  Widget _buildMenuSection", r"  Widget _buildMenuSection", content, flags=re.DOTALL)

# Remove _buildTasteProfileCircles and _buildTasteAxisCircle
content = re.sub(r"  Widget _buildTasteProfileCircles\(\) \{.*?  void _showEditTasteProfileSheet", r"  void _showEditTasteProfileSheet", content, flags=re.DOTALL)

# Remove _buildAchievementCard
content = re.sub(r"  Widget _buildAchievementCard\(.*?\}\n\n/// Modal", r"/// Modal", content, flags=re.DOTALL)

# Remove _buildMenuSection, _buildMenuItem, _buildMenuDivider
content = re.sub(r"  Widget _buildMenuSection\(.*?  Widget _buildHistorySection", r"  Widget _buildHistorySection", content, flags=re.DOTALL)

# Remove _TasteProfileEditorSheet class
content = re.sub(r"class _TasteProfileEditorSheet extends StatefulWidget \{.*", r"", content, flags=re.DOTALL)

with open('lib/features/main/presentation/screens/profile_screen.dart', 'w') as f:
    f.write(content)
