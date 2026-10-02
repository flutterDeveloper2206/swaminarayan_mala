import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/mantra_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/jap_widgets.dart';
import '../../core/widgets/tilak_chandlo_mark.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  String _selectedDeity = 'swaminarayan';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final state = context.read<AppState>();
    final mantra = MantraConstants.seedMantras.firstWhere(
      (m) => m.deityId == _selectedDeity,
      orElse: () => MantraConstants.seedMantras.first,
    );
    await state.completeOnboarding(deityId: _selectedDeity, mantraId: mantra.id);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      _OnboardPage(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        child: const TilakChandloMark(
          size: 150,
          showGlow: true,
          filled: false,
          animate: true,
          repeatPulse: true,
        ),
      ),
      _OnboardPage(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        child: Column(
          children: [
            Text('108', style: AppTextStyles.counter()),
            const SizedBox(height: 8),
            Text('1008 · ${l10n.customTarget}', style: AppTextStyles.caption()),
          ],
        ),
      ),
      _OnboardPage(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _chip(l10n.dailyProgress),
            _chip(l10n.weeklyProgress),
            _chip(l10n.monthlyProgress),
            _chip(l10n.currentStreak),
          ],
        ),
      ),
      _OnboardPage(
        title: l10n.onboardingTitle4,
        description: l10n.onboardingDesc4,
        child: Column(
          children: [
            Text(l10n.selectDeity, style: AppTextStyles.title()),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MantraConstants.deities.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final d = MantraConstants.deities[i];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDeity = d.id),
                    child: DeityImage(
                      deityId: d.id,
                      size: 72,
                      selected: _selectedDeity == d.id,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: DevotionalBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(l10n.skip),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => pages[i],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i ? AppColors.primary : AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: AppButton(
                  label: _page == pages.length - 1 ? l10n.getStarted : l10n.next,
                  onPressed: () {
                    if (_page == pages.length - 1) {
                      _finish();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: AppTextStyles.caption(color: AppColors.textPrimary)),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          const SizedBox(height: 36),
          Text(title, textAlign: TextAlign.center, style: AppTextStyles.heading()),
          const SizedBox(height: 12),
          Text(description, textAlign: TextAlign.center, style: AppTextStyles.body()),
        ],
      ),
    );
  }
}
