import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/demo_sessions.dart';
import '../data/session_repository.dart';
import '../data/shared_preferences_session_repository.dart';
import '../domain/progress_period.dart';
import '../domain/progress_statistics.dart';
import '../domain/session_record.dart';
import 'widgets/history_list.dart';
import 'widgets/period_selector.dart';
import 'widgets/reading_speed_chart.dart';
import 'widgets/summary_cards_row.dart';

/// The Progress and History Screen (Slide 12).
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
    this.repository,
    this.initialSessions,
    this.referenceDate,
  });

  final SessionRepository? repository;
  final List<SessionRecord>? initialSessions;
  final DateTime? referenceDate;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final SessionRepository _repository;
  ProgressPeriod _selectedPeriod = ProgressPeriod.sevenDays;
  List<SessionRecord> _sessions = [];
  bool _isLoading = true;
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? SharedPreferencesSessionRepository();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    if (widget.initialSessions != null) {
      setState(() {
        _sessions = widget.initialSessions!;
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    final loaded = await _repository.getSessions();
    if (mounted) {
      setState(() {
        _sessions = loaded;
        _isLoading = false;
        _isPreviewMode = false;
      });
    }
  }

  void _togglePreviewDemoData() {
    setState(() {
      if (_isPreviewMode) {
        _isPreviewMode = false;
        _loadSessions();
      } else {
        _isPreviewMode = true;
        _sessions = DemoSessions.createSampleSessions(
          referenceDate: widget.referenceDate,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.paper,
        body: Center(child: CircularProgressIndicator(color: AppColors.green)),
      );
    }

    final stats = ProgressStatistics.compute(
      sessions: _sessions,
      period: _selectedPeriod,
      referenceDate: widget.referenceDate,
    );

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.green,
          backgroundColor: AppColors.card,
          onRefresh: _loadSessions,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Title and Period Selector (Slide 12)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: -0.5,
                      ),
                    ),
                    PeriodSelector(
                      selectedPeriod: _selectedPeriod,
                      onChanged: (period) {
                        setState(() => _selectedPeriod = period);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Preview banner toggle if user has no real sessions or is viewing demo
                if (_sessions.isEmpty || _isPreviewMode)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isPreviewMode
                            ? AppColors.greenLight
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isPreviewMode
                              ? AppColors.green
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isPreviewMode
                                ? Icons.visibility
                                : Icons.info_outline,
                            size: 18,
                            color: _isPreviewMode
                                ? AppColors.green
                                : AppColors.inkSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _isPreviewMode
                                  ? 'Viewing presentation demo data (not saved).'
                                  : 'No sessions recorded yet.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _isPreviewMode
                                    ? AppColors.green
                                    : AppColors.inkSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _togglePreviewDemoData,
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: AppColors.ink,
                            ),
                            child: Text(
                              _isPreviewMode
                                  ? 'Clear demo'
                                  : 'Load preview data',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Three metric cards
                SummaryCardsRow(statistics: stats),
                const SizedBox(height: 16),

                // Reading Speed chart
                ReadingSpeedChart(statistics: stats),
                const SizedBox(height: 16),

                // History section
                HistoryList(sessions: stats.filteredSessions),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
