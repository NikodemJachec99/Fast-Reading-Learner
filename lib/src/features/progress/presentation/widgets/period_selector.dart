import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/progress_period.dart';

/// Segmented pill control for selecting 7 days vs 30 days.
class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final ProgressPeriod selectedPeriod;
  final ValueChanged<ProgressPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ProgressPeriod.values.map((period) {
          final isSelected = period == selectedPeriod;
          return Semantics(
            button: true,
            selected: isSelected,
            label: period.label,
            child: InkWell(
              onTap: () => onChanged(period),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ink : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  period.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.inkSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
