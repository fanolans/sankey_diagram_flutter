import 'package:flutter/foundation.dart';

class SankeyController extends ChangeNotifier {
  String? _highlightedNodeId;

  String? get highlightedNodeId => _highlightedNodeId;

  void highlight(String nodeId) {
    if (_highlightedNodeId == nodeId) return;
    _highlightedNodeId = nodeId;
    notifyListeners();
  }

  void clearHighlight() {
    if (_highlightedNodeId == null) return;
    _highlightedNodeId = null;
    notifyListeners();
  }
}
