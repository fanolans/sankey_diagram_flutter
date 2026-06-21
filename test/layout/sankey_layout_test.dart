import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

void main() {
  const size = Size(400, 600);
  const style = SankeyStyle(nodePadding: 10, nodeWidth: 16);

  SankeyData twoNodeData({double value = 100}) => SankeyData(
        nodes: const [
          SankeyNode(
            id: 'A',
            label: 'A',
            color: Color(0xFF0000FF),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'B',
            label: 'B',
            color: Color(0xFFFF0000),
            type: SankeyNodeType.seller,
          ),
        ],
        links: [SankeyLink(sourceId: 'A', targetId: 'B', value: value)],
      );

  group('SankeyLayout.compute', () {
    test('empty data returns empty result', () {
      final result = SankeyLayout.compute(
        data: const SankeyData(nodes: [], links: []),
        size: size,
        style: style,
      );
      expect(result.nodes, isEmpty);
      expect(result.links, isEmpty);
      expect(result.numColumns, 0);
    });

    test('two nodes produce two columns', () {
      final result = SankeyLayout.compute(
        data: twoNodeData(),
        size: size,
        style: style,
      );
      expect(result.numColumns, 2);
      expect(result.nodes.length, 2);
    });

    test('buyer node placed at x=0', () {
      final result = SankeyLayout.compute(
        data: twoNodeData(),
        size: size,
        style: style,
      );
      expect(result.nodes['A']!.rect.left, 0.0);
    });

    test('seller node placed at right edge', () {
      final result = SankeyLayout.compute(
        data: twoNodeData(),
        size: size,
        style: style,
      );
      final sellerX = result.nodes['B']!.rect.left;
      expect(sellerX, closeTo(size.width - style.nodeWidth, 0.01));
    });

    test('link count matches data links', () {
      final result = SankeyLayout.compute(
        data: twoNodeData(),
        size: size,
        style: style,
      );
      expect(result.links.length, 1);
    });

    test('link thickness proportional to value within the same layout', () {
      // Two buyers feeding one seller; larger link must have greater thickness.
      const data = SankeyData(
        nodes: [
          SankeyNode(
            id: 'A',
            label: 'A',
            color: Color(0xFF0000FF),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'C',
            label: 'C',
            color: Color(0xFF00FF00),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'B',
            label: 'B',
            color: Color(0xFFFF0000),
            type: SankeyNodeType.seller,
          ),
        ],
        links: [
          SankeyLink(sourceId: 'A', targetId: 'B', value: 100),
          SankeyLink(sourceId: 'C', targetId: 'B', value: 50),
        ],
      );
      final result = SankeyLayout.compute(data: data, size: size, style: style);
      final linkA = result.links.firstWhere((l) => l.link.sourceId == 'A');
      final linkC = result.links.firstWhere((l) => l.link.sourceId == 'C');
      expect(linkA.thickness, greaterThan(linkC.thickness));
    });

    test('node heights are proportional to values', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(
            id: 'A',
            label: 'A',
            color: Color(0xFF0000FF),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'C',
            label: 'C',
            color: Color(0xFF00FF00),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'B',
            label: 'B',
            color: Color(0xFFFF0000),
            type: SankeyNodeType.seller,
          ),
        ],
        links: [
          SankeyLink(sourceId: 'A', targetId: 'B', value: 200),
          SankeyLink(sourceId: 'C', targetId: 'B', value: 100),
        ],
      );

      final result = SankeyLayout.compute(data: data, size: size, style: style);
      final hA = result.nodes['A']!.rect.height;
      final hC = result.nodes['C']!.rect.height;

      expect(hA, closeTo(hC * 2, 1.0));
    });

    test('nodes in same column do not overlap', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(
            id: 'A',
            label: 'A',
            color: Color(0xFF0000FF),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'C',
            label: 'C',
            color: Color(0xFF00FF00),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'B',
            label: 'B',
            color: Color(0xFFFF0000),
            type: SankeyNodeType.seller,
          ),
        ],
        links: [
          SankeyLink(sourceId: 'A', targetId: 'B', value: 100),
          SankeyLink(sourceId: 'C', targetId: 'B', value: 100),
        ],
      );

      final result = SankeyLayout.compute(data: data, size: size, style: style);
      final nA = result.nodes['A']!.rect;
      final nC = result.nodes['C']!.rect;

      // One of them must end before the other starts (with padding)
      final topNode = nA.top < nC.top ? nA : nC;
      final bottomNode = nA.top < nC.top ? nC : nA;

      expect(topNode.bottom, lessThanOrEqualTo(bottomNode.top));
    });

    test('sortOrder.byValue places largest node first', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(
            id: 'small',
            label: 'small',
            color: Color(0xFF0000FF),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'large',
            label: 'large',
            color: Color(0xFF00FF00),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'B',
            label: 'B',
            color: Color(0xFFFF0000),
            type: SankeyNodeType.seller,
          ),
        ],
        links: [
          SankeyLink(sourceId: 'small', targetId: 'B', value: 10),
          SankeyLink(sourceId: 'large', targetId: 'B', value: 500),
        ],
      );

      final result = SankeyLayout.compute(
        data: data,
        size: size,
        style: const SankeyStyle(sortOrder: SortOrder.byValue),
      );

      expect(
        result.nodes['large']!.rect.top,
        lessThanOrEqualTo(result.nodes['small']!.rect.top),
      );
    });

    test('link sourceY is within source node bounds', () {
      final result =
          SankeyLayout.compute(data: twoNodeData(), size: size, style: style);
      final link = result.links[0];
      final srcRect = link.sourceNode.rect;

      expect(link.sourceY, greaterThanOrEqualTo(srcRect.top - 0.1));
      expect(link.sourceY, lessThanOrEqualTo(srcRect.bottom + 0.1));
    });

    test('link targetY is within target node bounds', () {
      final result =
          SankeyLayout.compute(data: twoNodeData(), size: size, style: style);
      final link = result.links[0];
      final tgtRect = link.targetNode.rect;

      expect(link.targetY, greaterThanOrEqualTo(tgtRect.top - 0.1));
      expect(link.targetY, lessThanOrEqualTo(tgtRect.bottom + 0.1));
    });

    test('three-column layout with neutral nodes', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(
            id: 'src',
            label: 'Source',
            color: Color(0xFF0000FF),
            type: SankeyNodeType.buyer,
          ),
          SankeyNode(
            id: 'mid',
            label: 'Middle',
            color: Color(0xFF00FF00),
            type: SankeyNodeType.neutral,
          ),
          SankeyNode(
            id: 'dst',
            label: 'Dest',
            color: Color(0xFFFF0000),
            type: SankeyNodeType.seller,
          ),
        ],
        links: [
          SankeyLink(sourceId: 'src', targetId: 'mid', value: 100),
          SankeyLink(sourceId: 'mid', targetId: 'dst', value: 100),
        ],
      );

      final result = SankeyLayout.compute(data: data, size: size, style: style);
      expect(result.numColumns, 3);
      expect(result.nodes['src']!.column, 0);
      expect(result.nodes['mid']!.column, 1);
      expect(result.nodes['dst']!.column, 2);
    });
  });
}
