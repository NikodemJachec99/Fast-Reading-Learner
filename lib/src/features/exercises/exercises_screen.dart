import 'package:flutter/material.dart';

import 'exercise.dart';

/// Lists the exercises and lets the user choose which round to start.
class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key, this.onStartRound, this.levels = const {}});

  /// Starts a round for the tapped exercise once the round flow is connected.
  final ValueChanged<Exercise>? onStartRound;

  /// Current levels for exercises the user has already started.
  final Map<Exercise, ExerciseLevel> levels;

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  ExerciseCategory? _selectedCategory;

  void _startRound(Exercise exercise) {
    final startRound = widget.onStartRound;
    if (startRound != null) {
      startRound(exercise);
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Rounds are coming soon.')));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final light = colors.brightness == Brightness.light;
    final background = light ? const Color(0xFFF7F5EE) : colors.surface;
    final surface = light ? Colors.white : colors.surfaceContainer;
    final ink = light ? const Color(0xFF163B34) : colors.onSurface;
    final line = light ? const Color(0xFFDCE3DD) : colors.outlineVariant;
    final muted = light ? const Color(0xFF55695F) : colors.onSurfaceVariant;
    final accent = light ? const Color(0xFF16846C) : colors.primary;
    final onAccent = light ? Colors.white : colors.onPrimary;
    final exercises = Exercise.values.where(
      (exercise) =>
          _selectedCategory == null || exercise.category == _selectedCategory,
    );

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Exercises'),
        backgroundColor: background,
        foregroundColor: ink,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final category in [null, ...ExerciseCategory.values])
                        ChoiceChip(
                          label: Text(category?.label ?? 'All'),
                          selected: _selectedCategory == category,
                          showCheckmark: false,
                          backgroundColor: surface,
                          selectedColor: accent,
                          side: BorderSide(
                            color: _selectedCategory == category
                                ? accent
                                : line,
                          ),
                          labelStyle: TextStyle(
                            color: _selectedCategory == category
                                ? onAccent
                                : ink,
                          ),
                          shape: const StadiumBorder(),
                          onSelected: (_) =>
                              setState(() => _selectedCategory = category),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    key: ValueKey(_selectedCategory),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: [
                      for (final exercise in exercises)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _ExerciseCard(
                            exercise: exercise,
                            level: widget.levels[exercise],
                            surface: surface,
                            ink: ink,
                            muted: muted,
                            line: line,
                            accent: accent,
                            onTap: exercise.isLocked
                                ? null
                                : () => _startRound(exercise),
                          ),
                        ),
                    ],
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

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.level,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.accent,
    required this.onTap,
  });

  final Exercise exercise;
  final ExerciseLevel? level;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color line;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final (badge, badgeInk) = switch (exercise.category) {
      ExerciseCategory.reading => (
        const Color(0xFFDCF0E5),
        const Color(0xFF106350),
      ),
      ExerciseCategory.comprehension => (
        const Color(0xFFFCECE6),
        const Color(0xFF974E3D),
      ),
      ExerciseCategory.memory => (
        const Color(0xFFEDE8FA),
        const Color(0xFF5B4691),
      ),
    };
    final currentLevel = level?.number ?? 0;
    final status = exercise.isLocked
        ? 'Locked'
        : currentLevel == 0
        ? 'New'
        : 'Level $currentLevel';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: badge,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  exercise.number.toString().padLeft(2, '0'),
                  style: text.titleSmall?.copyWith(
                    color: badgeInk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.category.label,
                      style: text.labelMedium?.copyWith(color: muted),
                    ),
                    Text(
                      exercise.title,
                      style: text.titleMedium?.copyWith(
                        color: ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      exercise.description,
                      style: text.bodyMedium?.copyWith(color: muted),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (!exercise.isLocked)
                          ExcludeSemantics(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (final dot in ExerciseLevel.values)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 2),
                                    child: Icon(
                                      dot.number <= currentLevel
                                          ? Icons.circle
                                          : Icons.circle_outlined,
                                      color: dot.number <= currentLevel
                                          ? accent
                                          : muted,
                                      size: 8,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Text(
                          status,
                          style: text.labelMedium?.copyWith(color: muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                exercise.isLocked ? Icons.lock_outline : Icons.chevron_right,
                color: muted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
