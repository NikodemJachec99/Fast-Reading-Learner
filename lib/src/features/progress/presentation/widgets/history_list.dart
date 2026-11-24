import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/session_record.dart';
import 'session_card.dart';

/// List of past reading practice sessions (Slide 12).
class HistoryList extends StatelessWidget {
  const HistoryList({super.key, required this.sessions});

  final List<SessionRecord> sessions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 40,
                  color: AppColors.inkSecondary,
                ),
                SizedBox(height: 10),
                Text(
                  'No sessions in this period',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Complete exercises and tests to see your reading history here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.inkSecondary),
                ),
              ],
            ),
          )
        else
          ...sessions.map((s) => SessionCard(key: ValueKey(s.id), session: s)),
      ],
    );
  }
}
