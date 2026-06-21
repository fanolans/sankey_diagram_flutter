import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/sankey_bloc.dart';
import '../../../shared/widgets/sankey_page_scaffold.dart';
import '../data/financing_repository.dart';

class FinancingPage extends StatelessWidget {
  const FinancingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SankeyBloc(const FinancingRepository()),
      child: const SankeyPageScaffold(),
    );
  }
}
