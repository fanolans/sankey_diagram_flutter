import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../bloc/sankey_bloc.dart';
import '../bloc/sankey_event.dart';
import '../bloc/sankey_state.dart';

class SankeyPageScaffold extends StatefulWidget {
  const SankeyPageScaffold({super.key});

  @override
  State<SankeyPageScaffold> createState() => _SankeyPageScaffoldState();
}

class _SankeyPageScaffoldState extends State<SankeyPageScaffold> {
  @override
  void initState() {
    super.initState();
    context.read<SankeyBloc>().add(const SankeyLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SankeyBloc, SankeyState>(
      builder: (context, state) => switch (state) {
        SankeyInitial() || SankeyLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        SankeyError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 32),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        SankeyLoaded(:final config) =>
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    config.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ),
                SankeyDiagram(
                  data: config.data,
                  height: config.height,
                  style: config.style,
                  buyerLabel: config.buyerLabel,
                  sellerLabel: config.sellerLabel,
                  buyerLabelStyle: config.buyerLabelStyle,
                  sellerLabelStyle: config.sellerLabelStyle,
                  legendItems: config.legendItems,
                  onNodeTap: (node) => context
                      .read<SankeyBloc>()
                      .add(SankeyNodeTapped(node)),
                  onLinkTap: (link) => context
                      .read<SankeyBloc>()
                      .add(SankeyLinkTapped(link)),
                ),
              ],
            ),
          ),
      },
    );
  }
}
