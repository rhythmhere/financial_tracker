import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _currencyCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currencyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    _nameCtrl.text = app.profile?.name ?? '';
    _currencyCtrl.text = app.profile?.currency ?? 'USD';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _currencyCtrl, decoration: const InputDecoration(labelText: 'Currency Code (e.g., USD)')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () async {
                  final name = _nameCtrl.text.trim();
                  final cc = _currencyCtrl.text.trim();
                  if (name.isEmpty || cc.isEmpty) return;
                  await context.read<AppState>().upsertProfile(Profile(name: name, currency: cc));
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
                },
                child: const Text('Save')),
            const SizedBox(height: 12),
            const Text('All data is stored locally and will be deleted if the app is uninstalled.'),
          ],
        ),
      ),
    );
  }
}
