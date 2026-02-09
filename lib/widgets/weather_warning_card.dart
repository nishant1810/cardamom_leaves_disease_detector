import 'package:flutter/material.dart';

class WeatherWarningCard extends StatelessWidget {
  final bool rainExpected;
  final bool highWind;
  final bool highHumidity;

  const WeatherWarningCard({
    super.key,
    required this.rainExpected,
    required this.highWind,
    required this.highHumidity,
  });

  @override
  Widget build(BuildContext context) {
    // If no warnings, don't render anything
    if (!rainExpected && !highWind && !highHumidity) {
      return const SizedBox.shrink();
    }

    final List<String> warnings = [];

    if (rainExpected) {
      warnings.add("Rain expected – avoid spraying today");
    }
    if (highWind) {
      warnings.add("High wind – spray may drift");
    }
    if (highHumidity) {
      warnings.add("High humidity – disease spread risk");
    }

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: warnings.map(
                    (warning) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    "• $warning",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
