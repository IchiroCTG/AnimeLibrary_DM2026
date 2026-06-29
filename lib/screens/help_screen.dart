import 'package:anime_library/theme/app_colors.dart';
import 'package:anime_library/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  List<_FaqItem> _faqs(AppLocalizations l) => [
        _FaqItem(question: l.faq1Q, answer: l.faq1A),
        _FaqItem(question: l.faq2Q, answer: l.faq2A),
        _FaqItem(question: l.faq3Q, answer: l.faq3A),
        _FaqItem(question: l.faq4Q, answer: l.faq4A),
        _FaqItem(question: l.faq5Q, answer: l.faq5A),
        _FaqItem(question: l.faq6Q, answer: l.faq6A),
        _FaqItem(question: l.faq7Q, answer: l.faq7A),
      ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.helpTitle, style: AppTextStyles.headline3),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Banner ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1040), AppColors.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.help_outline_rounded,
                      color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.helpCenter, style: AppTextStyles.headline3),
                      const SizedBox(height: 4),
                      Text(l.helpCenterDesc, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(l.helpFaq, style: AppTextStyles.headline3),
          const SizedBox(height: 12),

          ..._faqs(l).map((faq) => _FaqTile(item: faq)),

          const SizedBox(height: 24),

          // ── Contacto ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.helpContact, style: AppTextStyles.headline3),
                const SizedBox(height: 8),
                Text(l.helpContactDesc, style: AppTextStyles.bodySmall),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.mail_outline_rounded, size: 18),
                    label: Text(l.helpContactBtn),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}

class _FaqTile extends StatelessWidget {
  final _FaqItem item;
  const _FaqTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textSecondary,
          title: Text(item.question, style: AppTextStyles.bodyMedium),
          children: [
            Text(
              item.answer,
              style: AppTextStyles.bodySmall
                  .copyWith(height: 1.6, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
