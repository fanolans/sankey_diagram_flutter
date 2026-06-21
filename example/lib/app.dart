import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc/theme_bloc.dart';
import 'core/bloc/theme_event.dart';
import 'core/bloc/theme_state.dart';
import 'core/theme/app_theme.dart';
import 'features/apbn/presentation/apbn_page.dart';
import 'features/broker/presentation/broker_page.dart';
import 'features/ecommerce/presentation/ecommerce_page.dart';
import 'features/export_import/presentation/export_import_page.dart';
import 'features/financing/presentation/financing_page.dart';
import 'features/survey/presentation/survey_page.dart';

class SankeyDemoApp extends StatelessWidget {
  const SankeyDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => MaterialApp(
          title: 'Sankey Diagram',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeState.mode,
          debugShowCheckedModeBanner: false,
          home: const _HomeScreen(),
        ),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sankey Diagram Demo'),
          actions: [
            Row(
              spacing: 4,
              children: [
                Text(isDark ? '🌛' : '🌞',
                    style: const TextStyle(fontSize: 20)),
                Switch(
                  value: isDark,
                  onChanged: (_) =>
                      context.read<ThemeBloc>().add(const ThemeToggleRequested()),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Broker Distribution'),
              Tab(text: 'Financing'),
              Tab(text: 'E-Commerce Journey'),
              Tab(text: 'Survey'),
              Tab(text: 'Ekspor'),
              Tab(text: 'APBN 2024'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BrokerPage(),
            FinancingPage(),
            EcommercePage(),
            SurveyPage(),
            ExportImportPage(),
            ApbnPage(),
          ],
        ),
      ),
    );
  }
}
