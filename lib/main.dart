import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'data/store.dart';
import 'features/tracker_page.dart';
import 'features/mind_page.dart';
import 'features/nutrition_page.dart';
import 'features/flow_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  runApp(const NoroFlowApp());
}

class NoroFlowApp extends StatelessWidget {
  const NoroFlowApp({super.key});
  @override
  Widget build(BuildContext context) =>
      MaterialApp(title: 'NoroFlow', debugShowCheckedModeBanner: false, theme: buildTheme(), home: const Shell());
}

/// Alt gezinme çubuğu ile 4 ana modülü barındırır.
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _i = 0;
  static const _pages = [TrackerPage(), MindPage(), NutritionPage(), FlowPage()];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: IndexedStack(index: _i, children: _pages)),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _i,
          onDestinationSelected: (v) => setState(() => _i = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.timer_outlined), label: 'Sayaç'),
            NavigationDestination(icon: Icon(Icons.self_improvement), label: 'Zihin'),
            NavigationDestination(icon: Icon(Icons.eco_outlined), label: 'Beslenme'),
            NavigationDestination(icon: Icon(Icons.bolt_outlined), label: 'Flow'),
          ],
        ),
      );
}
