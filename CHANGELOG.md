## 1.1.0

- Add `autoLayout` mode: column positions derived automatically from link
  topology using BFS (longest-path depth), matching d3-sankey behaviour.
- Add iterative relaxation (`layoutIterations`, default 6) that minimises
  link crossings and aligns nodes with their neighbours.
- Add `NodeAlignment` enum (`left`, `right`, `center`, `justify`) to control
  sink/source placement during auto-layout.
- Add circular link support: backward flows (source column ≥ target column)
  are detected (`LayoutLink.isCircular`) and rendered as upward arcs.
- Fix `numColumns` to use `max + 1` instead of `distinctCount` so non-
  contiguous explicit columns are positioned correctly.

## 1.0.1

- Add dartdoc comments to all public API classes, enums, and methods.
- Limit pubspec screenshots to 10 (pub.dev maximum).

## 1.0.0

- Initial version.
