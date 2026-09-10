import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/providers/locale_provider.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:kukula_app/core/theme/app_theme.dart';

class LanguageSelectScreen extends ConsumerWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo / Icon
              const Center(
                child: Text('🐔', style: TextStyle(fontSize: 72)),
              ),
              const SizedBox(height: 24),
              Text(
                'Easy Poultry Manager',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'ගොවිපල කළමනාකරු',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
              ),
              const SizedBox(height: 56),

              // Language cards
              Text(
                'Select Language / භාෂාව තෝරන්න',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
              ),
              const SizedBox(height: 24),

              // English
              _LanguageCard(
                flag: '🇬🇧',
                label: 'English',
                sublabel: 'English',
                onTap: () async {
                  await ref.read(localeProvider.notifier).setEnglish();
                  if (context.mounted) context.go(AppRoutes.welcome);
                },
              ),
              const SizedBox(height: 16),

              // Sinhala
              _LanguageCard(
                flag: '🇱🇰',
                label: 'සිංහල',
                sublabel: 'Sinhala',
                onTap: () async {
                  await ref.read(localeProvider.notifier).setSinhala();
                  if (context.mounted) context.go(AppRoutes.welcome);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String flag;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.flag,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardDark,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
