import 'package:flutter/material.dart';
import 'package:ishari/features/scaffold/presentation/pages/main_scaffold.dart';

/// Entry point for the `/home` route.
///
/// Delegates all rendering to [MainScaffold] which provides the 5-tab
/// bottom navigation shell.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routePath = '/home';

  @override
  Widget build(BuildContext context) => const MainScaffold();
}
