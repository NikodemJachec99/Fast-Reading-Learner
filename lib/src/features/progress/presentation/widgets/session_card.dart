import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/session_record.dart';

/// Single session history item card matching Slide 12.
class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session});

  final SessionRecord session;

  @override
  Widget build(BuildContext context) {
    final passed = session.isPassed;
    final formattedTime = _formatTimestamp(session.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Left: Exercise & Text Title, Timestamp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${session.exerciseTitle} · ${session.textTitle}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.inkSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Right: Speed and Score Pill
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${session.wpm} wpm',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: passed
                      ? AppColors.greenLight
                      : AppColors.mutedAmberLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: passed
                        ? AppColors.green.withValues(alpha: 0.3)
                        : AppColors.mutedAmber.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${session.questionsCorrect}/${session.totalQuestions}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: passed ? AppColors.green : AppColors.mutedAmber,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(dt.year, dt.month, dt.day);
    final differenceDays = today.difference(sessionDay).inDays;

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    if (differenceDays == 0) {
      return 'Today, $hour:$minute';
    } else if (differenceDays == 1) {
      return 'Yesterday, $hour:$minute';
    } else if (differenceDays < 7) {
      const weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return weekdays[dt.weekday - 1];
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}';
    }
  }
}
