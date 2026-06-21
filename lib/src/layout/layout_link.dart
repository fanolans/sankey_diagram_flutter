import '../models/sankey_link.dart';
import 'layout_node.dart';

/// Computed layout geometry for a single [SankeyLink] ribbon.
///
/// [sourceY] and [targetY] are the vertical midpoints on their respective node
/// bars. [thickness] is the ribbon height in canvas pixels.
/// [isCircular] is `true` when the link flows backward (source column ≥
/// target column), indicating a feedback/return flow.
class LayoutLink {
  const LayoutLink({
    required this.link,
    required this.sourceNode,
    required this.targetNode,
    required this.sourceY,
    required this.targetY,
    required this.thickness,
    this.isCircular = false,
  });

  final SankeyLink link;
  final LayoutNode sourceNode;
  final LayoutNode targetNode;

  final double sourceY;
  final double targetY;
  final double thickness;

  /// `true` when this link flows backward (source column ≥ target column).
  final bool isCircular;

  @override
  String toString() => 'LayoutLink(${link.sourceId}→${link.targetId}, '
      'srcY: $sourceY, tgtY: $targetY, thickness: $thickness'
      '${isCircular ? ", circular" : ""})';
}
