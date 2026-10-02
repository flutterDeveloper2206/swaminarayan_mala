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
import '../../data/models/mantra_model.dart';

class MantraListScreen extends StatelessWidget {
  const MantraListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DevotionalBackground(
        dark: dark,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(l10n.mantraLibrary, style: AppTextStyles.heading(dark: dark)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.mantrasAdd),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.mantras.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return AppCard(
                        onTap: () async {
                          await state.selectMantra('mantra_namavali_path');
                          if (!context.mounted) return;
                          Navigator.pushNamed(
                            context,
                            AppRoutes.jap,
                            arguments: 'mantra_namavali_path',
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.saffronGlow,
                              ),
                              child: const Center(
                                child: Text(
                                  '108',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sahajanand Namavali Path',
                                    style: AppTextStyles.title(dark: dark),
                                  ),
                                  Text(
                                    '108 remembrance beads · original labels',
                                    style: AppTextStyles.caption(dark: dark),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.play_circle_fill, color: AppColors.primary),
                          ],
                        ),
                      );
                    }
                    final m = state.mantras[i - 1];
                    return AppCard(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.mantrasDetail,
                        arguments: m.id,
                      ),
                      child: Row(
                        children: [
                          DeityImage(deityId: m.deityId, size: 52),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.text, style: AppTextStyles.title(dark: dark)),
                                Text(m.transliteration, style: AppTextStyles.caption(dark: dark)),
                                Row(
                                  children: [
                                    Text('${l10n.todayJap}: ', style: AppTextStyles.caption(dark: dark)),
                                    AnimatedCounter(
                                      value: state.todayCountForMantra(m.id),
                                      style: AppTextStyles.caption(dark: dark),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('${l10n.totalJap}: ', style: AppTextStyles.caption(dark: dark)),
                                    AnimatedCounter(
                                      value: m.totalCount,
                                      style: AppTextStyles.caption(dark: dark),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              m.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: AppColors.templeRed,
                            ),
                            onPressed: () => state.toggleMantraFavorite(m.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_circle_fill, color: AppColors.primary),
                            onPressed: () async {
                              await state.selectMantra(m.id);
                              if (!context.mounted) return;
                              Navigator.pushNamed(context, AppRoutes.jap, arguments: m.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddMantraScreen extends StatefulWidget {
  const AddMantraScreen({super.key});

  @override
  State<AddMantraScreen> createState() => _AddMantraScreenState();
}

class _AddMantraScreenState extends State<AddMantraScreen> {
  final _name = TextEditingController();
  final _text = TextEditingController();
  final _trans = TextEditingController();
  final _target = TextEditingController(text: '108');
  String _deityId = 'swaminarayan';

  @override
  void dispose() {
    _name.dispose();
    _text.dispose();
    _trans.dispose();
    _target.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _text.text.trim().isEmpty) return;
    final state = context.read<AppState>();
    await state.addMantra(
      name: _name.text.trim(),
      text: _text.text.trim(),
      transliteration: _trans.text.trim(),
      deityId: _deityId,
      target: int.tryParse(_target.text) ?? 108,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DevotionalBackground(
        dark: dark,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(l10n.addMantra, style: AppTextStyles.heading(dark: dark)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(controller: _name, decoration: InputDecoration(labelText: l10n.mantraName)),
              const SizedBox(height: 12),
              TextField(controller: _text, decoration: InputDecoration(labelText: l10n.mantraText)),
              const SizedBox(height: 12),
              TextField(
                controller: _trans,
                decoration: InputDecoration(labelText: l10n.mantraName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _target,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.customTarget),
              ),
              const SizedBox(height: 12),
              Text(l10n.optionalDeity, style: AppTextStyles.caption(dark: dark)),
              const SizedBox(height: 8),
              SizedBox(
                height: 72,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final d in MantraConstants.deities)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _deityId = d.id),
                          child: DeityImage(deityId: d.id, size: 64, selected: _deityId == d.id),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppButton(label: l10n.save, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class MantraDetailScreen extends StatelessWidget {
  const MantraDetailScreen({super.key, required this.mantraId});

  final String mantraId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    MantraModel? found;
    for (final item in state.mantras) {
      if (item.id == mantraId) {
        found = item;
        break;
      }
    }

    if (found == null) {
      return Scaffold(body: Center(child: Text(l10n.errorGeneric)));
    }
    final m = found;

    return Scaffold(
      body: DevotionalBackground(
        dark: dark,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    if (m.isCustom)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                        onPressed: () async {
                          final ok = await ConfirmationDialog.show(
                            context,
                            title: l10n.deleteMantra,
                            message: l10n.areYouSure,
                            confirmLabel: l10n.delete,
                            cancelLabel: l10n.cancel,
                          );
                          if (ok && context.mounted) {
                            await state.deleteMantra(m.id);
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                      ),
                  ],
                ),
                DeityImage(deityId: m.deityId, size: 120, selected: true),
                const SizedBox(height: 20),
                Text(m.text, style: AppTextStyles.mantra(dark: dark)),
                Text(m.transliteration, style: AppTextStyles.body(dark: dark)),
                const SizedBox(height: 12),
                AnimatedCounter(
                  value: m.totalCount,
                  style: AppTextStyles.counter(dark: dark).copyWith(fontSize: 36),
                ),
                const Spacer(),
                AppButton(
                  label: l10n.startJap,
                  onPressed: () async {
                    await state.selectMantra(m.id);
                    if (!context.mounted) return;
                    Navigator.pushNamed(context, AppRoutes.jap, arguments: m.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
