import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'models/network_controller.dart';
import 'screens/home_screen.dart';
import 'screens/activity_one_screen.dart';
import 'screens/activity_two_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/network_monitor_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => NetworkController()),
      ],
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'Lab Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/activity-one': (context) => const ActivityOneScreen(),
        '/activity-two': (context) => const ActivityTwoScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/network-monitor': (context) => const NetworkMonitorScreen(),
      },
    );
  }
}
