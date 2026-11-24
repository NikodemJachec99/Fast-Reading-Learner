import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/progress_period.dart';
import '../../domain/progress_statistics.dart';

/// Reading speed chart widget (Slide 12).
class ReadingSpeedChart extends StatelessWidget {
  const ReadingSpeedChart({super.key, required this.statistics});

  final ProgressStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final trend = statistics.trendWpm;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Trend Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reading speed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: trend >= 0 ? AppColors.greenLight : AppColors.paper,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: trend >= 0
                          ? AppColors.green.withValues(alpha: 0.3)
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    trend >= 0 ? '+$trend wpm' : '$trend wpm',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: trend >= 0
                          ? AppColors.green
                          : AppColors.inkSecondary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Chart Area
          SizedBox(height: 140, child: _buildChartContent(context)),
          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(color: AppColors.green, label: 'test passed'),
              const SizedBox(width: 20),
              _buildLegendItem(color: AppColors.mutedAmber, label: 'below 2/3'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartContent(BuildContext context) {
    final points = statistics.chartPoints;

    // Find max WPM among points to normalize bar height (minimum 300 scale)
    var maxWpm = 250;
    for (final p in points) {
      if (p.wpm != null && p.wpm! > maxWpm) {
        maxWpm = p.wpm!;
      }
    }
    // Add headroom
    maxWpm = (maxWpm * 1.15).round();

    if (statistics.period == ProgressPeriod.sevenDays) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: points.map((point) {
          return Expanded(
            child: _BarItem(point: point, maxWpm: maxWpm, compact: false),
          );
        }).toList(),
      );
    }

    // 30 days view: horizontally scrollable so bars don't overcrowd
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          thumbVisibility: false,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Show latest days first
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: points.map((point) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: SizedBox(
                    width: math.max(22.0, (constraints.maxWidth - 60) / 14),
                    child: _BarItem(
                      point: point,
                      maxWpm: maxWpm,
                      compact: true,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.inkSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.point,
    required this.maxWpm,
    required this.compact,
  });

  final DailySpeedPoint point;
  final int maxWpm;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final wpm = point.wpm;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // WPM Label on top of bar
        SizedBox(
          height: 14,
          child: wpm != null
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$wpm',
                    style: TextStyle(
                      fontSize: compact ? 9 : 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 4),

        // Bar or empty placeholder
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final double barHeight;
              final Color barColor;
              if (wpm != null) {
                barHeight = (wpm / maxWpm * availableHeight).clamp(
                  8.0,
                  availableHeight,
                );
                barColor = point.hasPassed
                    ? AppColors.green
                    : AppColors.mutedAmber;
              } else {
                barHeight = 0;
                barColor = Colors.transparent;
              }

              return Align(
                alignment: Alignment.bottomCenter,
                child: wpm != null
                    ? Container(
                        width: compact ? 12 : 24,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      )
                    : Container(
                        width: compact ? 6 : 12,
                        height: 2,
                        color: AppColors.border,
                      ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),

        // Day label below
        SizedBox(
          height: 14,
          child: Text(
            point.dayLabel,
            style: TextStyle(
              fontSize: compact ? 9 : 11,
              color: AppColors.inkSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
