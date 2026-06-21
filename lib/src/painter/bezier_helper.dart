import 'dart:math' as math;
import 'dart:ui';

import '../layout/layout_link.dart';

class BezierHelper {
  const BezierHelper._();

  static Path buildLinkPath(
    LayoutLink link, {
    double animationValue = 1.0,
    double nodeOverlap = 0,
  }) {
    final x0 = link.sourceNode.rect.right - nodeOverlap;
    final x1 = link.targetNode.rect.left + nodeOverlap;
    final mx = (x0 + x1) / 2;
    final y0 = link.sourceY;
    final y1 = link.targetY;
    final w = link.thickness * animationValue;

    if (w <= 0) return Path();

    return Path()
      ..moveTo(x0, y0)
      ..cubicTo(mx, y0, mx, y1, x1, y1)
      ..lineTo(x1, y1 + w)
      ..cubicTo(mx, y1 + w, mx, y0 + w, x0, y0 + w)
      ..close();
  }

  static bool hitTestLink(LayoutLink link, Offset point,
      {double tolerance = 8.0}) {
    final x0 = link.sourceNode.rect.right;
    final x1 = link.targetNode.rect.left;
    final mx = (x0 + x1) / 2;
    final y0 = link.sourceY - tolerance;
    final y1 = link.targetY - tolerance;
    final w = link.thickness + tolerance * 2;
    if (w <= 0) return false;
    return (Path()
          ..moveTo(x0, y0)
          ..cubicTo(mx, y0, mx, y1, x1, y1)
          ..lineTo(x1, y1 + w)
          ..cubicTo(mx, y1 + w, mx, y0 + w, x0, y0 + w)
          ..close())
        .contains(point);
  }

  static bool hitTestNode(Rect rect, Offset point) => rect.contains(point);

  /// Builds the filled ribbon path for a circular (backward) link.
  ///
  /// The ribbon arcs upward above the diagram. Add [SankeyStyle.verticalPadding]
  /// to create visible space for these arcs when the diagram contains feedback
  /// flows.
  static Path buildCircularLinkPath(
    LayoutLink link, {
    double animationValue = 1.0,
  }) {
    final x0 = link.sourceNode.rect.right;
    final x1 = link.targetNode.rect.left;
    final y0 = link.sourceY;
    final y1 = link.targetY;
    final w = link.thickness * animationValue;

    if (w <= 0) return Path();

    // Arc height is proportional to the horizontal span of the backward jump
    final span = (x0 - x1).abs();
    final arcTop = math.min(y0, y1) - math.max(span * 0.4, 40.0) - w;

    return Path()
      ..moveTo(x0, y0)
      ..cubicTo(x0, arcTop, x1, arcTop, x1, y1)
      ..lineTo(x1, y1 + w)
      ..cubicTo(x1, arcTop + w, x0, arcTop + w, x0, y0 + w)
      ..close();
  }
}
