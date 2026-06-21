import 'package:flutter/foundation.dart';

/// Programmatically controls node highlight state from outside the diagram.
///
/// Pass an instance to [SankeyDiagram.controller] and call [highlight] or
/// [clearHighlight] to dim/focus nodes without user interaction.
class SankeyController extends ChangeNotifier {
  String? _highlightedNodeId;

  /// The [SankeyNode.id] of the currently highlighted node, or `null`.
  String? get highlightedNodeId => _highlightedNodeId;

  /// Highlights the node with [nodeId], dimming all others.
  void highlight(String nodeId) {
    if (_highlightedNodeId == nodeId) return;
    _highlightedNodeId = nodeId;
    notifyListeners();
  }

  /// Removes any active highlight, restoring all nodes to full opacity.
  void clearHighlight() {
    if (_highlightedNodeId == null) return;
    _highlightedNodeId = null;
    notifyListeners();
  }
}
