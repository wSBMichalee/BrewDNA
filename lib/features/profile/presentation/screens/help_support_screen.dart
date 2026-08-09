import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // TODO: contact email
  static const String _contactEmail = 'kontakt@brewdna.app';

  final List<Map<String, String>> _faqItems = [
    {
      'question': 'Jak działa algorytm BrewDNA?',
      'answer':
          'BrewDNA analizuje Twoje oceny, preferowane poziomy goryczki (IBU), aromaty chmielowe i słodowe, tworząc Twój unikalny genom smakowy i rekomendując idealnie dopasowane piwa kraftowe.',
    },
    {
      'question': 'Jak skanować etykiety piw?',
      'answer':
          'Wybierz zakładkę Skanuj w dolnym menu, skieruj aparat na etykietę butelki lub puszki. Nasze AI rozpozna styl, browar oraz wskaże procent dopasowania do Twojego profilu.',
    },
    {
      'question': 'Jak dodać własną recenzję i ocenę?',
      'answer':
          'W karcie dowolnego piwa kliknij przycisk „Oceń”. Możesz ocenić piwo w skali 1–5 gwiazdek, zaznaczyć wyczuwalne nuty smakowe i dodać własną notatkę degustacyjną.',
    },
    {
      'question': 'Czym różni się subskrypcja Premium?',
      'answer':
          'Pakiet Premium odblokowuje nielimitowane skanowanie AI, pełną mapę kraftowych pubów i browarów, zaawansowane wglądy w DNA smakowe oraz ekskluzywne karty do udostępniania.',
    },
  ];

  final Set<int> _expandedIndices = {0};

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _contactEmail,
      queryParameters: {
        'subject': 'Pytanie / Zgłoszenie — BrewDNA',
      },
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await _copyEmailToClipboard();
      }
    } catch (_) {
      await _copyEmailToClipboard();
    }
  }

  Future<void> _copyEmailToClipboard() async {
    await Clipboard.setData(const ClipboardData(text: _contactEmail));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.label,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Text(
            'Skopiowano adres e-mail do schowka: $_contactEmail',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: AppColors.separator.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Icon(
              CupertinoIcons.back,
              color: AppColors.label,
              size: 24,
            ),
          ),
        ),
        middle: Text(
          'Pomoc i wsparcie',
          style: AppTypography.headline.copyWith(
            color: AppColors.label,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacings.s20,
            vertical: AppSpacings.s24,
          ),
          children: [
            // Karta Powitalna / Hero
            Container(
              padding: EdgeInsets.all(AppSpacings.s20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.accent, AppColors.accentDeep],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.chat_bubble_2_fill,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: AppSpacings.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Masz pytania?',
                          style: AppTypography.headline.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Jesteśmy tu, aby pomóc Ci odkrywać najlepsze piwa.',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacings.s32),

            // Sekcja FAQ
            _buildSectionHeader('NAJCZĘŚCIEJ ZADAWANE PYTANIA (FAQ)'),
            SizedBox(height: AppSpacings.s12),
            ...List.generate(_faqItems.length, (index) {
              final item = _faqItems[index];
              final isExpanded = _expandedIndices.contains(index);

              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacings.s12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.separator.withValues(alpha: 0.6),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedIndices.remove(index);
                            } else {
                              _expandedIndices.add(index);
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacings.s16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['question']!,
                                  style: AppTypography.subhead.copyWith(
                                    color: AppColors.label,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? CupertinoIcons.chevron_up
                                    : CupertinoIcons.chevron_down,
                                size: 16,
                                color: AppColors.labelSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s16),
                          child: Divider(
                            height: 1,
                            thickness: 0.5,
                            color: AppColors.separator.withValues(alpha: 0.5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppSpacings.s16),
                          child: Text(
                            item['answer']!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.labelSecondary,
                              height: 1.45,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),

            SizedBox(height: AppSpacings.s24),

            // Sekcja: Kontakt
            _buildSectionHeader('SKONTAKTUJ SIĘ Z NAMI'),
            SizedBox(height: AppSpacings.s12),
            Container(
              padding: EdgeInsets.all(AppSpacings.s20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.separator.withValues(alpha: 0.6),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          CupertinoIcons.mail_solid,
                          color: AppColors.accent,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: AppSpacings.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Adres e-mail wsparcia',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.labelSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _contactEmail,
                              style: AppTypography.subhead.copyWith(
                                color: AppColors.label,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.s20),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(14),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onPressed: _sendEmail,
                          child: Text(
                            'Napisz wiadomość',
                            style: AppTypography.subhead.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacings.s12),
                      CupertinoButton(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        padding: const EdgeInsets.all(12),
                        onPressed: _copyEmailToClipboard,
                        child: const Icon(
                          CupertinoIcons.doc_on_doc,
                          color: AppColors.label,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacings.s32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s8),
      child: Text(
        title,
        style: AppTypography.caption.copyWith(
          color: AppColors.labelSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          fontSize: 12,
        ),
      ),
    );
  }
}
