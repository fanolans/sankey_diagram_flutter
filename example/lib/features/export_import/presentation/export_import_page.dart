import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/sankey_bloc.dart';
import '../../../shared/widgets/sankey_page_scaffold.dart';
import '../data/export_import_repository.dart';

class ExportImportPage extends StatelessWidget {
  const ExportImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SankeyBloc(const ExportImportRepository()),
      child: const SankeyPageScaffold(),
    );
  }
}
