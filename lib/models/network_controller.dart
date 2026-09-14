import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetInterface { wifi, cellular, offline }

enum RequestStatus { pending, running, queued, success, failed }

class QueuedRequest {
  final String id;
  final String label;
  RequestStatus status;
  int attempts;

  QueuedRequest({
    required this.id,
    required this.label,
    this.status = RequestStatus.pending,
    this.attempts = 0,
  });
}

class NetworkController extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetInterface _current = NetInterface.offline;
  final List<QueuedRequest> _queue = [];
  final List<String> _log = [];
  bool _isDraining = false;

  NetInterface get current => _current;
  List<QueuedRequest> get queue => List.unmodifiable(_queue);
  List<String> get log => List.unmodifiable(_log);

  NetworkController() {
    _init();
  }

  Future<void> _init() async {
    final initial = await _connectivity.checkConnectivity();
    _updateInterface(initial);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final previous = _current;
      _updateInterface(results);

      final justCameOnline =
          previous == NetInterface.offline && _current != NetInterface.offline;
      if (justCameOnline) {
        _addLog('Connection restored (${_current.name}) — draining queue');
        _drainQueue();
      } else {
        _addLog('Network changed -> ${_current.name}');
      }
    });
  }

  void _updateInterface(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      _current = NetInterface.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      _current = NetInterface.cellular;
    } else {
      _current = NetInterface.offline;
    }
    notifyListeners();
  }

  void _addLog(String message) {
    _log.insert(0, '${DateTime.now().toIso8601String().substring(11, 19)}  $message');
    if (_log.length > 30) _log.removeLast();
    notifyListeners();
  }

  Future<void> sendRequest(String label) async {
    final request = QueuedRequest(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      label: label,
    );
    _queue.add(request);
    _addLog('Request "$label" created');
    await _attempt(request);
  }

  Future<void> _attempt(QueuedRequest request) async {
    if (_current == NetInterface.offline) {
      request.status = RequestStatus.queued;
      _addLog('"${request.label}" queued — offline');
      notifyListeners();
      return;
    }

    request.status = RequestStatus.running;
    request.attempts++;
    notifyListeners();
    _addLog('"${request.label}" sending (attempt ${request.attempts})...');

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (_current == NetInterface.offline) {
        throw Exception('Connection dropped mid-request (handover)');
      }

      if (Random().nextDouble() < 0.15) {
        throw Exception('Simulated handover packet loss');
      }

      request.status = RequestStatus.success;
      _addLog('"${request.label}" succeeded');
      _queue.removeWhere((r) => r.id == request.id);
    } catch (e) {
      request.status = RequestStatus.queued;
      _addLog('"${request.label}" failed ($e) — queued for retry');
    }
    notifyListeners();
  }

  Future<void> _drainQueue() async {
    if (_isDraining) return;
    _isDraining = true;
    final pending = _queue.where((r) => r.status == RequestStatus.queued).toList();
    for (final request in pending) {
      if (_current == NetInterface.offline) break;
      await _attempt(request);
    }
    _isDraining = false;
  }

  void retryNow() => _drainQueue();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
