import 'package:flutter/material.dart';
import 'package:network_settings_state/network_settings_state.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'network_settings_state example',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NetworkSettingsSnapshot? _snapshot;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadSnapshot();

    NetworkSettingsState.onChanged.listen(
      (snapshot) => setState(() => _snapshot = snapshot),
      onError: (error) => setState(() => _error = error),
    );
  }

  Future<void> _loadSnapshot() async {
    try {
      final snapshot = await NetworkSettingsState.getSnapshot();
      setState(() => _snapshot = snapshot);
    } catch (error) {
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;

    return Scaffold(
      appBar: AppBar(title: const Text('network_settings_state')),
      body: Center(
        child: _error != null
            ? Text('Error: $_error')
            : snapshot == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Wi-Fi enabled: ${snapshot.wifiEnabled}'),
                      const SizedBox(height: 8),
                      Text(
                        'Mobile data enabled: '
                        '${snapshot.mobileDataEnabled?.toString() ?? "unknown (iOS)"}',
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadSnapshot,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
