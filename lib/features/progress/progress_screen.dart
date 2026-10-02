import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/helpers/date_helper.dart';
import '../../core/helpers/number_helper.dart';
import '../../core/providers/app_state.dart';
import '../../core/services/analytics_service.dart';
import '../../core/widgets/app_widgets.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/jap_widgets.dart';
import '../../core/widgets/tilak_chandlo_mark.dart';
import '../../data/local/local_database.dart';
import '../../data/models/daily_progress_model.dart';

enum _AnalyticsTab { today, week, month, year, life }

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  _AnalyticsTab _tab = _AnalyticsTab.today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final analytics = AnalyticsService.instance;
    final today = analytics.today();
    final week = analytics.weekStats();
    final month = analytics.monthStats();
    final year = analytics.yearStats();
    final life = analytics.lifetime();
    final insights = analytics.insights();
    final locale = state.settings.languageCode;
    final progress = today.target > 0
        ? (today.totalCount / today.target).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      body: DevotionalBackground(
        dark: dark,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                sliver: SoftSliverList(
                  children: [
                    Row(
                      children: [
                        if (Navigator.canPop(context))
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        Expanded(
                          child: Text(
                            l10n.yourSadhana,
                            style: AppTextStyles.heading(dark: dark),
                          ),
                        ),
                        const TilakChandloMark(
                          size: 36,
                          showGlow: false,
                          filled: false,
                          animate: false,
                          repeatPulse: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Hero: today progress + streak
                    AppCard(
                      goldBorder: true,
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      child: Row(
                        children: [
                          _TodayRing(
                            progress: progress,
                            count: today.totalCount,
                            dark: dark,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.aajKiSadhana,
                                  style: AppTextStyles.title(dark: dark),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    AnimatedCounter(
                                      value: today.totalCount,
                                      style: AppTextStyles.caption(dark: dark),
                                    ),
                                    Text(
                                      ' / ',
                                      style: AppTextStyles.caption(dark: dark),
                                    ),
                                    AnimatedCounter(
                                      value: today.target,
                                      style: AppTextStyles.caption(dark: dark),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.saffron.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_fire_department_rounded,
                                        color: AppColors.streak,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        l10n.daysStreak(life.currentStreak),
                                        style: AppTextStyles.body(dark: dark).copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.saffronDeep,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      '${l10n.longestStreak}: ',
                                      style: AppTextStyles.caption(dark: dark),
                                    ),
                                    AnimatedCounter(
                                      value: life.longestStreak,
                                      enableSeparator: false,
                                      style: AppTextStyles.caption(dark: dark),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Period chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _TabChip(
                            label: l10n.todaysProgress,
                            selected: _tab == _AnalyticsTab.today,
                            onTap: () => setState(() => _tab = _AnalyticsTab.today),
                          ),
                          _TabChip(
                            label: l10n.last7Days,
                            selected: _tab == _AnalyticsTab.week,
                            onTap: () => setState(() => _tab = _AnalyticsTab.week),
                          ),
                          _TabChip(
                            label: l10n.thisMonth,
                            selected: _tab == _AnalyticsTab.month,
                            onTap: () => setState(() => _tab = _AnalyticsTab.month),
                          ),
                          _TabChip(
                            label: l10n.thisYear,
                            selected: _tab == _AnalyticsTab.year,
                            onTap: () => setState(() => _tab = _AnalyticsTab.year),
                          ),
                          _TabChip(
                            label: l10n.lifetimeStats,
                            selected: _tab == _AnalyticsTab.life,
                            onTap: () => setState(() => _tab = _AnalyticsTab.life),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: KeyedSubtree(
                        key: ValueKey(_tab),
                        child: switch (_tab) {
                          _AnalyticsTab.today => _TodayPane(
                              today: today,
                              kidsCount: state.kidsJapCountToday(),
                              locale: locale,
                              dark: dark,
                              l10n: l10n,
                            ),
                          _AnalyticsTab.week => _WeekPane(
                              week: week,
                              locale: locale,
                              dark: dark,
                              l10n: l10n,
                            ),
                          _AnalyticsTab.month => _MonthPane(
                              month: month,
                              locale: locale,
                              dark: dark,
                              l10n: l10n,
                            ),
                          _AnalyticsTab.year => _StatsGrid(
                              items: [
                                (l10n.totalJap, year.totalNaam),
                                (l10n.totalMala, year.totalMala),
                                (l10n.sessions, year.totalSessions),
                                (l10n.activeDays, year.activeDays),
                              ],
                              dark: dark,
                            ),
                          _AnalyticsTab.life => _StatsGrid(
                              items: [
                                (l10n.totalJap, life.totalNaam),
                                (l10n.totalMala, life.totalMala),
                                (l10n.sessions, life.totalSessions),
                                (
                                  l10n.duration,
                                  NumberHelper.formatDuration(life.totalDurationSeconds),
                                ),
                                (l10n.activeDays, life.activeDays),
                                (l10n.longestStreak, life.longestStreak),
                              ],
                              dark: dark,
                            ),
                        },
                      ),
                    ),

                    if (insights.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(l10n.insights, style: AppTextStyles.title(dark: dark)),
                      const SizedBox(height: 8),
                      ...insights.map((ins) {
                        final text = switch (ins.type) {
                          'monthly' => l10n.insightMonthly(ins.count),
                          'consistency' =>
                            l10n.insightConsistency(ins.count, ins.extra ?? 30),
                          'bestDay' => l10n.insightBestDay(ins.count),
                          _ => '',
                        };
                        if (text.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.saffron.withValues(alpha: 0.15),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    color: AppColors.saffronDeep,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(text, style: AppTextStyles.body(dark: dark)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      l10n.privacyMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption(dark: dark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thin wrapper so we can pass a plain list into SliverChildListDelegate.
class SoftSliverList extends StatelessWidget {
  const SoftSliverList({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SliverList(delegate: SliverChildListDelegate(children));
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: selected ? AppColors.saffronGlow : null,
              color: selected ? null : AppColors.saffron.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected
                    ? Colors.transparent
                    : AppColors.saffron.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.saffronDeep,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayRing extends StatelessWidget {
  const _TodayRing({
    required this.progress,
    required this.count,
    required this.dark,
  });

  final double progress;
  final int count;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) {
        return SizedBox(
          width: 108,
          height: 108,
          child: CustomPaint(
            painter: _RingPainter(value),
            child: Center(child: child),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCounter(
            value: count,
            enableSeparator: false,
            style: AppTextStyles.title(dark: dark).copyWith(fontSize: 22),
          ),
          Text(
            'jap',
            style: AppTextStyles.caption(dark: dark).copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;
    final bg = Paint()
      ..color = AppColors.saffron.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..shader = AppColors.saffronGlow.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _TodayPane extends StatelessWidget {
  const _TodayPane({
    required this.today,
    required this.kidsCount,
    required this.locale,
    required this.dark,
    required this.l10n,
  });

  final DailyProgressModel today;
  final int kidsCount;
  final String locale;
  final bool dark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final normal = (today.totalCount - kidsCount).clamp(0, today.totalCount);
    return Column(
      children: [
        _StatsGrid(
          items: [
            (l10n.todayJap, today.totalCount),
            (l10n.todaysMala, today.malaCount),
            (l10n.normalJap, normal),
            (l10n.kidsJapCount, kidsCount),
            (l10n.sessions, today.sessionCount),
            (l10n.duration, NumberHelper.formatDuration(today.totalDurationSeconds)),
          ],
          dark: dark,
        ),
        if (today.targetCompleted) ...[
          const SizedBox(height: 10),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.targetCompleted,
                    style: AppTextStyles.body(dark: dark)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _WeekPane extends StatelessWidget {
  const _WeekPane({
    required this.week,
    required this.locale,
    required this.dark,
    required this.l10n,
  });

  final PeriodStats week;
  final String locale;
  final bool dark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(child: _BarChart(counts: week.dailyCounts, dark: dark)),
        const SizedBox(height: 10),
        _StatsGrid(
          items: [
            (l10n.totalJap, week.totalNaam),
            (l10n.dailyAverage, week.dailyAverage.toStringAsFixed(0)),
            (l10n.activeDays, week.activeDays),
            (l10n.bestDay, week.bestDayCount),
          ],
          dark: dark,
        ),
      ],
    );
  }
}

class _MonthPane extends StatelessWidget {
  const _MonthPane({
    required this.month,
    required this.locale,
    required this.dark,
    required this.l10n,
  });

  final PeriodStats month;
  final String locale;
  final bool dark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(child: _MonthHeatmap(dark: dark)),
        const SizedBox(height: 10),
        _StatsGrid(
          items: [
            (l10n.totalJap, month.totalNaam),
            (l10n.totalMala, month.totalMala),
            (l10n.activeDays, month.activeDays),
            (
              l10n.duration,
              NumberHelper.formatDuration(month.totalDurationSeconds),
            ),
          ],
          dark: dark,
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.items, required this.dark});

  /// Value is [int] (animated) or [String] (static e.g. duration).
  final List<(String, Object)> items;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final valueStyle = AppTextStyles.title(dark: dark).copyWith(
      color: AppColors.saffronDeep,
      fontSize: 20,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: AppCard(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: AppTextStyles.caption(dark: dark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (item.$2 is int)
                        AnimatedCounter(
                          value: item.$2 as int,
                          style: valueStyle,
                        )
                      else
                        Text('${item.$2}', style: valueStyle),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.counts, required this.dark});
  final Map<String, int> counts;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final entries = counts.entries.toList();
    final maxVal = entries.fold<int>(1, (m, e) => e.value > m ? e.value : m);
    const chartHeight = 180.0;
    const barMaxHeight = 100.0;

    return SizedBox(
      height: chartHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < entries.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: (entries[i].value / maxVal).clamp(0.0, 1.0),
                  ),
                  duration: Duration(milliseconds: 450 + i * 60),
                  curve: Curves.easeOutCubic,
                  builder: (_, t, __) {
                    final barHeight = (t * barMaxHeight).clamp(4.0, barMaxHeight);
                    final day = DateHelper.parseDateKey(entries[i].key);
                    final label =
                        ['M', 'T', 'W', 'T', 'F', 'S', 'S'][(day.weekday - 1) % 7];
                    final isToday = entries[i].key == DateHelper.todayKey();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${entries[i].value}',
                          style: AppTextStyles.caption(dark: dark).copyWith(fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: barHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: isToday
                                ? AppColors.chandloGradient
                                : AppColors.saffronGlow,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.glowSaffron,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: AppTextStyles.caption(dark: dark).copyWith(
                            fontSize: 11,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isToday ? AppColors.chandloRed : null,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MonthHeatmap extends StatelessWidget {
  const _MonthHeatmap({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final keys = DateHelper.monthKeys(now.year, now.month);
    final todayKey = DateHelper.todayKey();
    final db = LocalDatabase.instance;
    var max = 1;
    final counts = <String, int>{};
    for (final k in keys) {
      if (k.compareTo(todayKey) > 0) {
        counts[k] = 0;
        continue;
      }
      final c = db.getDayAggregate(k).totalCount;
      counts[k] = c;
      if (c > max) max = c;
    }

    // Align first day to weekday columns (Mon-start)
    final firstWeekday = DateHelper.parseDateKey(keys.first).weekday; // 1=Mon
    final leading = firstWeekday - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (d) => SizedBox(
                  width: 34,
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption(dark: dark).copyWith(fontSize: 11),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < leading; i++)
              const SizedBox(width: 34, height: 34),
            for (final k in keys)
              _HeatCell(
                day: DateHelper.parseDateKey(k).day,
                count: counts[k] ?? 0,
                max: max,
                isFuture: k.compareTo(todayKey) > 0,
                isToday: k == todayKey,
                dark: dark,
              ),
          ],
        ),
      ],
    );
  }
}

class _HeatCell extends StatelessWidget {
  const _HeatCell({
    required this.day,
    required this.count,
    required this.max,
    required this.isFuture,
    required this.isToday,
    required this.dark,
  });

  final int day;
  final int count;
  final int max;
  final bool isFuture;
  final bool isToday;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final intensity = max == 0 ? 0.0 : (count / max).clamp(0.0, 1.0);
    Color fill;
    if (isFuture) {
      fill = Colors.transparent;
    } else if (count == 0) {
      fill = dark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated;
    } else {
      fill = Color.lerp(
            AppColors.saffronSoft,
            AppColors.saffronDeep,
            intensity,
          ) ??
          AppColors.saffron;
    }

    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(
          color: isToday
              ? AppColors.chandloRed
              : count > 0
                  ? AppColors.saffron.withValues(alpha: 0.35)
                  : AppColors.cardBorder.withValues(alpha: 0.7),
          width: isToday ? 2 : 1,
        ),
        boxShadow: count > 0
            ? [
                BoxShadow(
                  color: AppColors.glowSaffron.withValues(alpha: 0.25 * intensity),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
      child: Text(
        '$day',
        style: TextStyle(
          fontSize: 11,
          fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
          color: count > 0
              ? Colors.white
              : (dark ? AppColors.darkTextMuted : AppColors.textMuted),
        ),
      ),
    );
  }
}
