import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/liability.dart';
import 'package:intl/intl.dart';
import '../theme.dart';

class LiabilitiesScreen extends StatelessWidget {
  const LiabilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final nf = NumberFormat.simpleCurrency(name: app.profile?.currency ?? 'USD');
        return Scaffold(
      body: app.liabilities.isEmpty
          ? Center(
              child: Text('No liabilities to display.', style: Theme.of(context).textTheme.bodyLarge),
            )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: app.liabilities.length,
        itemBuilder: (context, i) {
          final l = app.liabilities[i];
          return Dismissible(
            key: ValueKey(l.id ?? i),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            confirmDismiss: (d) async => await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text('Delete Liability', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                content: const Text('Are you sure you want to delete this liability?'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
                  TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
                ],
              ),
            ),
            onDismissed: (_) async {
              if (l.id == null) return;
              final messenger = ScaffoldMessenger.of(context);
              await context.read<AppState>().deleteLiability(l.id!);
              messenger.showSnackBar(const SnackBar(content: Text('Liability deleted')));
            },
            child: Card(
              elevation: 4,
              shadowColor: Colors.black.withAlpha(30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(l.type, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Builder(builder: (ctx) {
                  final parsed = DateTime.tryParse(l.dueDate);
                  final dueStr = parsed != null ? DateFormat.yMMMd().format(parsed) : l.dueDate;
                  return Text('Due: $dueStr', style: Theme.of(context).textTheme.bodySmall);
                }),
                trailing: Text(nf.format(l.amount), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: kPrimary)),
                onTap: () => _showForm(context, existing: l),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        heroTag: 'liabilities-fab',
      ),
    );
  }

  void _showForm(BuildContext context, {Liability? existing}) {
    final typeCtrl = TextEditingController(text: existing?.type ?? '');
    final amountCtrl = TextEditingController(text: existing != null ? existing.amount.toString() : '');
  DateTime due = existing != null ? (DateTime.tryParse(existing.dueDate) ?? DateTime.now()) : DateTime.now();

    

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 24, left: 24, right: 24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(existing == null ? 'Add Liability' : 'Edit Liability', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
              const SizedBox(height: 16),
              TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Due: ${DateFormat.yMd().format(due)}', style: Theme.of(context).textTheme.bodyLarge),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('Select Date'),
                    onPressed: () async {
                      final d = await showDatePicker(context: ctx, initialDate: due, firstDate: DateTime(2000), lastDate: DateTime(2100));
                      if (d != null) setState(() => due = d);
                    },
                  )
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () async {
                  final type = typeCtrl.text.trim();
                  final amount = double.tryParse(amountCtrl.text) ?? 0.0;
                  if (type.isEmpty || amount <= 0) return;
                  // Close sheet immediately, then perform DB update to avoid using ctx after await
                  Navigator.of(ctx).pop();
                  if (existing != null) {
                    existing.type = type;
                    existing.amount = amount;
                    existing.dueDate = due.toIso8601String();
                    await context.read<AppState>().updateLiability(existing);
                  } else {
                    await context.read<AppState>().addLiability(Liability(type: type, amount: amount, dueDate: due.toIso8601String()));
                  }
                },
                child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
            ]),
          );
        });
      },
    );
  }
}
