import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

void main() {
  const red = Color(0xFFFF0000);
  const blue = Color(0xFF0000FF);

  const nodeA = SankeyNode(
      id: 'A', label: 'Alpha', color: red, type: SankeyNodeType.buyer);
  const nodeB = SankeyNode(
      id: 'B', label: 'Beta', color: blue, type: SankeyNodeType.seller);
  const link = SankeyLink(sourceId: 'A', targetId: 'B', value: 42);

  group('SankeyNode', () {
    test('equality based on id + label + color + type', () {
      const copy = SankeyNode(
        id: 'A',
        label: 'Alpha',
        color: red,
        type: SankeyNodeType.buyer,
      );
      expect(nodeA, equals(copy));
    });

    test('copyWith replaces specified fields', () {
      final updated = nodeA.copyWith(label: 'Changed');
      expect(updated.label, 'Changed');
      expect(updated.id, nodeA.id);
    });

    test('hashCode consistent with equality', () {
      const same = SankeyNode(
        id: 'A',
        label: 'Alpha',
        color: red,
        type: SankeyNodeType.buyer,
      );
      expect(nodeA.hashCode, same.hashCode);
    });
  });

  group('SankeyLink', () {
    test('equality based on sourceId + targetId + value', () {
      const copy = SankeyLink(sourceId: 'A', targetId: 'B', value: 42);
      expect(link, equals(copy));
    });

    test('copyWith replaces specified fields', () {
      final updated = link.copyWith(value: 99);
      expect(updated.value, 99.0);
      expect(updated.sourceId, link.sourceId);
    });
  });

  group('SankeyData', () {
    test('nodeById returns correct node', () {
      const data = SankeyData(nodes: [nodeA, nodeB], links: [link]);
      expect(data.nodeById('A'), nodeA);
    });

    test('nodeById returns null for unknown id', () {
      const data = SankeyData(nodes: [nodeA], links: []);
      expect(data.nodeById('Z'), isNull);
    });

    test('outgoingLinks filters correctly', () {
      const data = SankeyData(nodes: [nodeA, nodeB], links: [link]);
      expect(data.outgoingLinks('A'), [link]);
      expect(data.outgoingLinks('B'), isEmpty);
    });

    test('incomingLinks filters correctly', () {
      const data = SankeyData(nodes: [nodeA, nodeB], links: [link]);
      expect(data.incomingLinks('B'), [link]);
      expect(data.incomingLinks('A'), isEmpty);
    });

    test('equality with same nodes and links', () {
      const d1 = SankeyData(nodes: [nodeA, nodeB], links: [link]);
      const d2 = SankeyData(nodes: [nodeA, nodeB], links: [link]);
      expect(d1, equals(d2));
    });

    test('copyWith creates independent copy', () {
      const original = SankeyData(nodes: [nodeA], links: [link]);
      final copy = original.copyWith(nodes: [nodeB]);
      expect(copy.nodes, [nodeB]);
      expect(original.nodes, [nodeA]);
    });
  });

  group('ValueFormatter', () {
    test('formats thousands', () {
      expect(ValueFormatter.format(1500), '1.50 K');
    });

    test('formats millions', () {
      expect(ValueFormatter.format(2500000), '2.50 M');
    });

    test('formats billions', () {
      expect(ValueFormatter.format(3750000000), '3.75 B');
    });

    test('formats trillions', () {
      expect(ValueFormatter.format(1000000000000), '1.00 T');
    });

    test('formats small values without suffix', () {
      expect(ValueFormatter.format(500), '500.00');
    });
  });
}
