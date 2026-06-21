import '../models/sankey_link.dart';
import 'layout_node.dart';

class LayoutLink {
  const LayoutLink({
    required this.link,
    required this.sourceNode,
    required this.targetNode,
    required this.sourceY,
    required this.targetY,
    required this.thickness,
  });

  final SankeyLink link;
  final LayoutNode sourceNode;
  final LayoutNode targetNode;

  final double sourceY;
  final double targetY;
  final double thickness;

  @override
  String toString() => 'LayoutLink(${link.sourceId}→${link.targetId}, '
      'srcY: $sourceY, tgtY: $targetY, thickness: $thickness)';
}
