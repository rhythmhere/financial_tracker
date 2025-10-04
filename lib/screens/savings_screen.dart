import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/saving.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final nf = NumberFormat.simpleCurrency(name: app.profile?.currency ?? 'USD');
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final messenger = ScaffoldMessenger.of(context);
          await app.initialize();
          messenger.showSnackBar(
            const SnackBar(content: Text('Savings updated'), duration: Duration(seconds: 2)),
          );
        },
        child: app.savings.isEmpty
            ? Center(
                child: Text('No savings entries to display.', style: Theme.of(context).textTheme.bodyLarge),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: app.savings.length,
                itemBuilder: (context, i) {
                  final s = app.savings[i];
                  final hasTarget = s.target != null && s.target! > 0;
                  final percent = hasTarget ? (s.amount / s.target!).clamp(0.0, 1.0) : 0.0;

                  return Dismissible(
                    key: ValueKey(s.id ?? i),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(Icons.delete, color: Colors.white, size: 28),
                    ),
                    confirmDismiss: (d) async => await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text('Delete Entry', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        content: const Text('Are you sure you want to delete this savings entry?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
                          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
                        ],
                      ),
                    ),
                    onDismissed: (_) async {
                      if (s.id == null) return;
                      final savingToRestore = Saving.fromMap(s.toMap());
                      final messenger = ScaffoldMessenger.of(context);
                      await context.read<AppState>().deleteSaving(s.id!);
                      messenger.showSnackBar(
                        SnackBar(
                          content: const Text('Savings entry deleted'),
                          action: SnackBarAction(label: 'Undo', onPressed: () => context.read<AppState>().addSaving(savingToRestore)),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black.withAlpha(30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(backgroundColor: kPrimary.withAlpha(30), child: Icon(_getIconForType(s.type), color: kPrimary)),
                              title: Text(s.type, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                              subtitle: Text('Saved on: ${DateFormat.yMMMd().format(DateTime.parse(s.date))}', style: Theme.of(context).textTheme.bodySmall),
                              trailing: Text(nf.format(s.amount), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: kTextPrimary)),
                              onTap: () => _showForm(context, existing: s),
                            ),
                            if (hasTarget) ...[
                              const SizedBox(height: 12),
                              Text('Goal: ${nf.format(s.target)}', style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 8),
                              LinearPercentIndicator(
                                lineHeight: 8.0,
                                percent: percent,
                                backgroundColor: Colors.grey[300],
                                progressColor: kPrimary,
                                barRadius: const Radius.circular(4),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        heroTag: 'savings-fab',
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'emergency fund':
        return Icons.healing;
      case 'retirement':
        return Icons.self_improvement;
      case 'vacation':
        return Icons.beach_access;
      default:
        return Icons.savings;
    }
  }

  void _showForm(BuildContext context, {Saving? existing}) {
    final typeCtrl = TextEditingController(text: existing?.type ?? '');
    final amountCtrl = TextEditingController(text: existing != null ? existing.amount.toString() : '');
    final targetCtrl = TextEditingController(text: existing?.target?.toString() ?? '');
    DateTime selected = existing != null ? DateTime.parse(existing.date) : DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 24, left: 24, right: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(existing == null ? 'Add Savings' : 'Edit Savings', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 24),
                    TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Type (e.g. Emergency Fund)', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
                    const SizedBox(height: 16),
                    TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))), keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    TextField(controller: targetCtrl, decoration: const InputDecoration(labelText: 'Target (optional)', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))), keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date: ${DateFormat.yMd().format(selected)}', style: Theme.of(context).textTheme.bodyLarge),
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: const Text('Select Date'),
                          onPressed: () async {
                            final d = await showDatePicker(context: ctx, initialDate: selected, firstDate: DateTime(2000), lastDate: DateTime(2100));
                            if (d != null) setState(() => selected = d);
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
                        final target = double.tryParse(targetCtrl.text);
                        if (type.isEmpty || amount <= 0) return;
                        final s = existing != null ? existing : Saving(type: type, amount: amount, date: selected.toIso8601String(), target: target);
                        // Close sheet before awaiting provider calls to avoid using ctx after async gap
                        Navigator.of(ctx).pop();
                        if (existing != null) {
                          s.type = type;
                          s.amount = amount;
                          s.date = selected.toIso8601String();
                          s.target = target;
                          await context.read<AppState>().updateSaving(s);
                        } else {
                          await context.read<AppState>().addSaving(s);
                        }
                      },
                      child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
