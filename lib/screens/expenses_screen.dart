import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';
import '../theme.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final nf = NumberFormat.simpleCurrency(name: app.profile?.currency ?? 'USD');
    return Scaffold(
      body: app.expenses.isEmpty
          ? Center(
              child: Text('No expenses to display.', style: Theme.of(context).textTheme.bodyLarge),
            )
          : RefreshIndicator(
              onRefresh: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await app.initialize();
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Expenses updated'), duration: Duration(seconds: 2)),
                      );
                    },
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: app.expenses.length,
                itemBuilder: (context, i) {
                  final e = app.expenses[i];
                  return Dismissible(
                    key: ValueKey(e.id ?? i),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(Icons.delete, color: Colors.white, size: 28),
                    ),
                    confirmDismiss: (dir) async {
                      final res = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text('Delete Expense', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          content: const Text('Are you sure you want to delete this expense?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
                          ],
                        ),
                      );
                      return res == true;
                    },
                    onDismissed: (_) async {
                      if (e.id == null) return;
                      final expenseToDelete = Expense.fromMap(e.toMap());
                      final messenger = ScaffoldMessenger.of(context);
                      await context.read<AppState>().deleteExpense(e.id!);
                      messenger.showSnackBar(
                        SnackBar(
                          content: const Text('Expense deleted'),
                          action: SnackBarAction(label: 'Undo', onPressed: () => context.read<AppState>().addExpense(expenseToDelete)),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black.withAlpha(30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(backgroundColor: kPrimary.withAlpha(30), child: Icon(_getIconForCategory(e.category), color: kPrimary)),
                        title: Text(e.category, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text(e.notes ?? '', style: Theme.of(context).textTheme.bodySmall),
                        trailing: Text(nf.format(e.amount), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: kTextPrimary)),
                        onTap: () => _showExpenseForm(context, existing: e),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseForm(context),
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        heroTag: 'expenses-fab',
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.fastfood;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'bills':
        return Icons.receipt;
      default:
        return Icons.category;
    }
  }

  void _showExpenseForm(BuildContext context, {Expense? existing}) {
    final categoryCtrl = TextEditingController(text: existing?.category ?? '');
    final amountCtrl = TextEditingController(text: existing != null ? existing.amount.toString() : '');
    final notesCtrl = TextEditingController(text: existing?.notes ?? '');
    DateTime selected = existing != null ? DateTime.parse(existing.date) : DateTime.now();

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(existing == null ? 'Add Expense' : 'Edit Expense', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24),
                TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
                const SizedBox(height: 16),
                TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))), keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
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
                    final cat = categoryCtrl.text.trim();
                    final amount = double.tryParse(amountCtrl.text) ?? 0.0;
                    if (cat.isEmpty || amount <= 0) return;
                    
                    final e = Expense(category: cat, amount: amount, date: selected.toIso8106String(), notes: notesCtrl.text.trim());
                    // Pop the sheet immediately, then perform DB work to avoid using ctx after await
                    Navigator.of(ctx).pop();
                    if (existing != null && existing.id != null) {
                      e.id = existing.id;
                      await context.read<AppState>().updateExpense(e);
                    } else {
                      await context.read<AppState>().addExpense(e);
                    }
                  },
                  child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
      },
    );
  }
}

extension on DateTime {
  String toIso8106String() {
    return toIso8601String();
  }
}
