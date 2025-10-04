import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'package:intl/intl.dart';
import '../models/investment.dart';
import '../theme.dart';

class InvestmentsScreen extends StatelessWidget {
  const InvestmentsScreen({super.key});

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
            const SnackBar(content: Text('Investments updated'), duration: Duration(seconds: 2)),
          );
        },
        child: app.investments.isEmpty
            ? Center(child: Text('No investments to display.', style: Theme.of(context).textTheme.bodyLarge))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: app.investments.length,
                itemBuilder: (context, i) {
                  final inv = app.investments[i];
                  return Dismissible(
                    key: ValueKey(inv.id ?? i),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(Icons.delete, color: Colors.white, size: 28),
                    ),
                    confirmDismiss: (d) async {
                      final res = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text('Delete Investment', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          content: const Text('Are you sure you want to delete this investment?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
                          ],
                        ),
                      );
                      return res == true;
                    },
                    onDismissed: (_) async {
                      if (inv.id == null) return;
                      final investmentToRestore = Investment.fromMap(inv.toMap());
                      final messenger = ScaffoldMessenger.of(context);
                      await context.read<AppState>().deleteInvestment(inv.id!);
                      messenger.showSnackBar(
                        SnackBar(
                          content: const Text('Investment deleted'),
                          action: SnackBarAction(label: 'Undo', onPressed: () => context.read<AppState>().addInvestment(investmentToRestore)),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black.withAlpha(30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(backgroundColor: kPrimary.withAlpha(30), child: Icon(_getIconForType(inv.type), color: kPrimary)),
                        title: Text(inv.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text('Qty: ${inv.quantity} @ ${nf.format(inv.currentPrice)}', style: Theme.of(context).textTheme.bodySmall),
                        trailing: Text(nf.format(inv.currentPrice * inv.quantity), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: kTextPrimary)),
                        onTap: () => _showAdd(context, existing: inv),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdd(context),
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
        heroTag: 'investments-fab',
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'stock':
        return Icons.show_chart;
      case 'crypto':
        return Icons.currency_bitcoin;
      case 'real estate':
        return Icons.house;
      default:
        return Icons.account_balance;
    }
  }

  void _showAdd(BuildContext context, {Investment? existing}) {
    final typeCtrl = TextEditingController(text: existing?.type ?? '');
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final buyCtrl = TextEditingController(text: existing != null ? existing.buyPrice.toString() : '');
    final currentCtrl = TextEditingController(text: existing != null ? existing.currentPrice.toString() : '');
    final qtyCtrl = TextEditingController(text: existing != null ? existing.quantity.toString() : '');
    DateTime selected = existing != null ? DateTime.parse(existing.date) : DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 24, left: 24, right: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(existing == null ? 'Add Investment' : 'Edit Investment', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Type (e.g. Stock, Crypto)', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
                  const SizedBox(height: 16),
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name (e.g. Apple Inc.)', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
                  const SizedBox(height: 16),
                  TextField(controller: buyCtrl, decoration: const InputDecoration(labelText: 'Buy Price', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))), keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  TextField(controller: currentCtrl, decoration: const InputDecoration(labelText: 'Current Price', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))), keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))), keyboardType: TextInputType.number),
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
                      final name = nameCtrl.text.trim();
                      final buy = double.tryParse(buyCtrl.text) ?? 0.0;
                      final current = double.tryParse(currentCtrl.text) ?? 0.0;
                      final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
                      if (type.isEmpty || name.isEmpty || qty <= 0) return;
                      final inv = Investment(
                        type: type,
                        name: name,
                        buyPrice: buy,
                        currentPrice: current,
                        quantity: qty,
                        date: selected.toIso8601String(),
                      );
                      // Close the sheet first to avoid using ctx after awaiting
                      Navigator.of(ctx).pop();
                      if (existing != null && existing.id != null) {
                        inv.id = existing.id;
                        await context.read<AppState>().updateInvestment(inv);
                      } else {
                        await context.read<AppState>().addInvestment(inv);
                      }
                    },
                    child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

