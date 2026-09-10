import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/enums/farm_type.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kukula_app/core/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmSetupScreen extends ConsumerStatefulWidget {
  const FarmSetupScreen({super.key});

  @override
  ConsumerState<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends ConsumerState<FarmSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _locationController = TextEditingController();
  FarmType? _selectedFarmType;
  bool _isLoading = false;

  @override
  void dispose() {
    _farmNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.farmSettings),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step indicator
              _StepIndicator(currentStep: 2, totalSteps: 3),
              const SizedBox(height: 32),

              Text(
                l10n.farmName,
                style: _labelStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _farmNameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Silva Poultry Farm',
                  prefixIcon: const Icon(Icons.agriculture_outlined),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Please enter your farm name'
                    : null,
              ),
              const SizedBox(height: 20),

              Text(l10n.farmLocation, style: _labelStyle),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Kurunegala, Sri Lanka',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 32),

              // Farm type selection
              Text(
                l10n.chooseFarmType,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),

              _FarmTypeCard(
                icon: '🥚',
                title: l10n.eggFarm,
                description: l10n.eggFarmDesc,
                accentColor: AppColors.eggAccent,
                isSelected: _selectedFarmType == FarmType.egg,
                onTap: () => setState(() => _selectedFarmType = FarmType.egg),
              ),
              const SizedBox(height: 12),

              _FarmTypeCard(
                icon: '🐔',
                title: l10n.meatFarm,
                description: l10n.meatFarmDesc,
                accentColor: AppColors.meatAccent,
                isSelected: _selectedFarmType == FarmType.meat,
                onTap: () => setState(() => _selectedFarmType = FarmType.meat),
              ),
              const SizedBox(height: 12),

              _FarmTypeCard(
                icon: '🐔',
                title: l10n.bothFarms,
                description: l10n.bothFarmsDesc,
                accentColor: AppColors.primary,
                isSelected: _selectedFarmType == FarmType.both,
                onTap: () => setState(() => _selectedFarmType = FarmType.both),
              ),

              if (_selectedFarmType == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select your farm type',
                    style: TextStyle(color: AppColors.error, fontSize: 13),
                  ),
                ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.continueBtn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedFarmType == null) {
      setState(() {}); // trigger rebuild to show error
      return;
    }

    setState(() => _isLoading = true);

    // ── Save farm name and type to providers ──
    final farmName = _farmNameController.text.trim();
    ref.read(farmNameProvider.notifier).state = farmName;
    ref.read(farmTypeProvider.notifier).state = _selectedFarmType!;

    // ── Persist selection so it survives app restarts ──
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('farmName', farmName);
    await prefs.setString('farmType', _selectedFarmType!.name);
    await prefs.setBool('onboardingDone', true);

    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.dashboard);
    }
  }

  TextStyle get _labelStyle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondaryDark,
      );
}

// ── Farm Type Card ────────────────────────────────────────────────────────
class _FarmTypeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _FarmTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? accentColor.withOpacity(0.12)
            : AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? accentColor : AppColors.borderDark,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? accentColor : AppColors.textPrimaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                // Checkmark
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: accentColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Step Indicator ────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final step = i + 1;
        final isActive = step == currentStep;
        final isDone = step < currentStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < totalSteps - 1 ? 8 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              decoration: BoxDecoration(
                color: isActive || isDone
                    ? AppColors.primary
                    : AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
