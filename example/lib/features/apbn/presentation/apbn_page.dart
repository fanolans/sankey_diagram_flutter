import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/sankey_bloc.dart';
import '../../../shared/widgets/sankey_page_scaffold.dart';
import '../data/apbn_repository.dart';

class ApbnPage extends StatelessWidget {
  const ApbnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SankeyBloc(const ApbnRepository()),
      child: const SankeyPageScaffold(),
    );
  }
}
