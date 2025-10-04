import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'package:intl/intl.dart';
import '../widgets/expense_bar_chart.dart';
import '../widgets/investment_pie_chart.dart';
import '../theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final nf = NumberFormat.simpleCurrency(name: app.profile?.currency ?? 'USD');

    return RefreshIndicator(
      onRefresh: () => app.initialize(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kBackgroundStart, kBackgroundEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Net Worth', style: Theme.of(context).textTheme.titleLarge),
                Chip(
                  avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
                  label: Text('${app.dailyLoggingStreak} Day Streak'),
                  backgroundColor: kPrimary.withAlpha(30),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: app.netWorth),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Text(
                  nf.format(value),
                  style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w800, color: kTextPrimary),
                );
              },
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(context, 'Monthly Expenses', nf.format(app.monthlyExpensesSummary(DateTime.now())), Icons.receipt_long, Colors.orange),
                _buildStatCard(context, 'Total Savings', nf.format(app.totalSavings), Icons.savings, Colors.green),
                _buildStatCard(context, 'Investments', nf.format(app.totalInvestmentsValue), Icons.show_chart, Colors.blue),
                _buildStatCard(context, 'Liabilities', nf.format(app.totalLiabilities), Icons.money_off, Colors.red),
              ],
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context,
              'Expense by Category (This Month)',
              SizedBox(height: 200, child: ExpenseBarChart(data: app.expensesByCategoryForMonth(DateTime.now()))),
            ),
            const SizedBox(height: 12),
            _buildChartCard(
              context,
              'Investment Allocation',
              SizedBox(height: 200, child: InvestmentPieChart(data: app.investmentAllocationByType())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: kTextPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, String title, Widget chart) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            chart,
          ],
        ),
      ),
    );
  }
}
