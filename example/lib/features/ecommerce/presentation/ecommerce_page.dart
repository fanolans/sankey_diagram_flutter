import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/sankey_bloc.dart';
import '../../../shared/widgets/sankey_page_scaffold.dart';
import '../data/ecommerce_repository.dart';

class EcommercePage extends StatelessWidget {
  const EcommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SankeyBloc(const EcommerceRepository()),
      child: const SankeyPageScaffold(),
    );
  }
}
