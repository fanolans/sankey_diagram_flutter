import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/sankey_bloc.dart';
import '../../../shared/widgets/sankey_page_scaffold.dart';
import '../data/broker_repository.dart';

class BrokerPage extends StatelessWidget {
  const BrokerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SankeyBloc(const BrokerRepository()),
      child: const SankeyPageScaffold(),
    );
  }
}
