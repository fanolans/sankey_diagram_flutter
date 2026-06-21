import 'package:flutter/material.dart';

import '../models/sankey_node.dart';
import '../models/sankey_style.dart';

class SankeyLegendItem {
  const SankeyLegendItem({required this.color, required this.label});

  final Color color;
  final String label;
}

class SankeyLegend extends StatelessWidget {
  const SankeyLegend({
    super.key,
    required this.items,
    required this.style,
    this.position = LegendPosition.bottom,
    this.onItemTap,
    this.highlightedLabel,
  });

  final List<SankeyLegendItem> items;
  final SankeyStyle style;
  final LegendPosition position;
  final ValueChanged<String>? onItemTap;
  final String? highlightedLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 6,
      children: items.map((item) {
        final isActive =
            highlightedLabel == null || item.label == highlightedLabel;
        return GestureDetector(
          onTap: () => onItemTap?.call(item.label),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isActive ? 1.0 : 0.35,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: item.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  item.label,
                  style: style.labelStyle?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ) ??
                      TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

List<SankeyLegendItem> deriveLegendItems(List<SankeyNode> nodes) {
  final seen = <String>{};
  final result = <SankeyLegendItem>[];
  for (final node in nodes) {
    final key = node.subLabel ?? node.type.name;
    if (seen.add(key)) {
      result.add(SankeyLegendItem(color: node.color, label: key));
    }
  }
  return result;
}
