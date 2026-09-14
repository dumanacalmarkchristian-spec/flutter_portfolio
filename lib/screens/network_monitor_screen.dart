import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/network_controller.dart';

class NetworkMonitorScreen extends StatelessWidget {
  const NetworkMonitorScreen({super.key});

  Color _statusColor(NetInterface iface) {
    switch (iface) {
      case NetInterface.wifi:
        return Colors.green;
      case NetInterface.cellular:
        return Colors.blue;
      case NetInterface.offline:
        return Colors.red;
    }
  }

  IconData _statusIcon(NetInterface iface) {
    switch (iface) {
      case NetInterface.wifi:
        return Icons.wifi;
      case NetInterface.cellular:
        return Icons.signal_cellular_alt;
      case NetInterface.offline:
        return Icons.wifi_off;
    }
  }

  Color _requestColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.running:
        return Colors.blue;
      case RequestStatus.queued:
        return Colors.orange;
      case RequestStatus.success:
        return Colors.green;
      case RequestStatus.failed:
        return Colors.red;
      case RequestStatus.pending:
        return Colors.grey;
    }
  }

  String _requestLabel(RequestStatus status) {
    switch (status) {
      case RequestStatus.running:
        return 'Running';
      case RequestStatus.queued:
        return 'Queued';
      case RequestStatus.success:
        return 'Done';
      case RequestStatus.failed:
        return 'Failed';
      case RequestStatus.pending:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final net = context.watch<NetworkController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Network Monitor')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: _statusColor(net.current).withAlpha(30),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(_statusIcon(net.current),
                          size: 36, color: _statusColor(net.current)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Active Interface',
                                style: Theme.of(context).textTheme.bodySmall),
                            Text(
                              net.current.name.toUpperCase(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () =>
                          net.sendRequest('Fetch dataset #${net.queue.length + 1}'),
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Send Request'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: net.retryNow,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Queue'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Request Queue (${net.queue.length})',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Expanded(
                flex: 2,
                child: net.queue.isEmpty
                    ? const Center(child: Text('No active or queued requests.'))
                    : ListView.builder(
                        itemCount: net.queue.length,
                        itemBuilder: (context, index) {
                          final r = net.queue[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 6,
                                backgroundColor: _requestColor(r.status),
                              ),
                              title: Text(r.label),
                              subtitle: Text(
                                  '${_requestLabel(r.status)} · Attempts: ${r.attempts}'),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Text('Event Log', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: net.log.length,
                    itemBuilder: (context, index) => Text(
                      net.log[index],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
