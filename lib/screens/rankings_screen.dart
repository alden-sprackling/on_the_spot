import 'package:flutter/material.dart';
import 'package:on_the_spot/providers/tier_provider.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/field_widget.dart';
import 'package:provider/provider.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _currentTierKey = GlobalKey();
  bool _scrolledToCurrent = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTier() {
    if (!_scrolledToCurrent && _currentTierKey.currentContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          _currentTierKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          alignment: 0.5,
        );
        _scrolledToCurrent = true;
      });
    }
  }

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
        final maxCount = tiers.fold(0, (sum, tier) => sum + tier.count);

        // Build the list of tier widgets as rows with a fixed label area and a horizontal bar
        final tierWidgets = tiers.map((tier) {
          final ratio = maxCount > 0 ? tier.count / maxCount : 0.0;
          final isCurrent = (myTier != null && myTier == tier.tier);
          final backgroundColor =
              AppColors.primaryColor.withAlpha((0.2 * 255).toInt());
          final fillColor = AppColors.primaryColor;

          return Padding(
            key: isCurrent ? _currentTierKey : null,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Fixed-width label column on the left
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tier.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'IQ: ${tier.minIq} - ${tier.maxIq}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                // Horizontal bar on the right
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        FractionallySizedBox(
                          widthFactor: ratio,
                          heightFactor: 1,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(12),
                              border: isCurrent
                                  ? Border.all(color: Colors.black, width: 2.0)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList();

        // Ensure we scroll to the current tier once built
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentTier());

        return SingleChildScrollView(
          controller: _scrollController,
          clipBehavior: Clip.none,
          child: FieldWidget(
            title: "RANKINGS",
            children: [
              Column(
                children: tierWidgets,
              ),
            ],
          ),
        );
      },
    );
  }
}