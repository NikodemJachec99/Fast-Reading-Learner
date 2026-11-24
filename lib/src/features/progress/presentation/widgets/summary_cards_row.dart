import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/progress_statistics.dart';

/// Row of three summary cards at the top of the Progress screen (Slide 12).
class SummaryCardsRow extends StatelessWidget {
  const SummaryCardsRow({super.key, required this.statistics});

  final ProgressStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final avgSpeedValue = statistics.averagePassedWpm != null
        ? '${statistics.averagePassedWpm}'
        : '—';
    final avgSpeedSub = statistics.averagePassedWpm != null
        ? 'wpm'
        : 'no passed tests';

    final compValue = statistics.totalQuestionsAsked > 0
        ? '${statistics.totalQuestionsCorrect}/${statistics.totalQuestionsAsked}'
        : '—';
    final compSub = statistics.totalQuestionsAsked > 0 ? 'correct' : 'no tests';

    final sessionsValue = '${statistics.completedSessionsCount}';
    const sessionsSub = 'completed';

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            title: 'Avg. speed',
            value: avgSpeedValue,
            subtitle: avgSpeedSub,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MetricCard(
            title: 'Comprehension',
            value: compValue,
            subtitle: compSub,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MetricCard(
            title: 'Sessions',
            value: sessionsValue,
            subtitle: sessionsSub,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.inkSecondary,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.inkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
