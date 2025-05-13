// lib/src/screens/rankings_screen.dart
import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/tier_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:on_the_spot/widgets/field_widget.dart';

class RankingsScreen extends StatelessWidget {
  const RankingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TierProvider>(
      builder: (context, tierProv, _) {
        if (tierProv.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final tiers = tierProv.tiers;
        final myTier = tierProv.myTier;
        if (tiers.isEmpty) {
          return const Center(child: Text('No ranking data.'));
        }

        // Find the max count for relative sizing
        final maxCount = tiers.map((t) => t.count).fold<int>(0, (prev, c) => c > prev ? c : prev);

        return SingleChildScrollView(
          child: FieldWidget(
            title: 'RANKINGS',
            children: tiers.map((tier) {
              final ratio = maxCount > 0 ? tier.count / maxCount : 0.0;
              final isCurrent = (myTier != null && myTier == tier.tier);
              // Choose colors based on current user's tier
              final backgroundColor = isCurrent
                  ? Colors.red.withAlpha((0.2 * 255).toInt())
                  : AppColors.primaryColor.withAlpha((0.2 * 255).toInt());
              final fillColor = isCurrent
                  ? Colors.red
                  : AppColors.primaryColor;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Label: min above max
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('IQ: ${tier.minIq}', style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 2),
                        Text('IQ: ${tier.maxIq}', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Bar
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: ratio,
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: fillColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          // Count label on left inside bar
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${tier.count}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
