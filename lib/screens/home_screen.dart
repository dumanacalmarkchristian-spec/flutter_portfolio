import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/activity_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Text(
                      appState.profileName.isNotEmpty
                          ? appState.profileName[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          appState.profileName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Activities', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    ActivityCard(
                      title: 'Activity 1: Counter Lab',
                      subtitle: 'Local state with StatefulWidget',
                      icon: Icons.exposure_plus_1,
                      onTap: () =>
                          Navigator.pushNamed(context, '/activity-one'),
                    ),
                    const SizedBox(height: 12),
                    ActivityCard(
                      title: 'Activity 2: Task Input Lab',
                      subtitle: 'Forms and local list state',
                      icon: Icons.checklist,
                      onTap: () =>
                          Navigator.pushNamed(context, '/activity-two'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
