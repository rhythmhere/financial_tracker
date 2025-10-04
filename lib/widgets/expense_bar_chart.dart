import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'glass_card.dart';

class ExpenseBarChart extends StatefulWidget {
  final Map<String, double> data; // category -> amount
  const ExpenseBarChart({super.key, required this.data});

  @override
  State<ExpenseBarChart> createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final bars = widget.data.entries.toList();
    if (bars.isEmpty) {
      return GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: SizedBox(
          height: 180,
          child: Center(child: Text('No expense data for this period', style: Theme.of(context).textTheme.bodyLarge)),
        ),
      );
    }

    final maxY = (bars.map((e) => e.value).fold<double>(0, (a, b) => a > b ? a : b)) * 1.1;

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: SizedBox(
        height: 220,
        child: LayoutBuilder(builder: (context, constraints) {
          final chartWidth = constraints.maxWidth;
          final barCount = bars.length;
          final availableSpace = barCount > 0 ? chartWidth / barCount : chartWidth;
          final showLabels = availableSpace > 70;  // Adjust this threshold as needed

          return BarChart(
            BarChartData(
              maxY: maxY > 0 ? maxY : 10,
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(
                enabled: true,
                touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex = response?.spot?.touchedBarGroupIndex;
                  });
                },
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipMargin: 6,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final title = bars[group.x.toInt()].key;
                    final value = bars[group.x.toInt()].value;
                    return BarTooltipItem(
                      '$title\n',
                      TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(243), fontWeight: FontWeight.w800, fontSize: 13),
                      children: [TextSpan(text: '\$${value.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(218), fontWeight: FontWeight.w600, fontSize: 12))],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36, interval: maxY / 4)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= bars.length) return const SizedBox();
                  return showLabels ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(bars[idx].key, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                  ) : const SizedBox();
                }))
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(bars.length, (i) {
                final val = bars[i].value;
                final isTouched = i == _touchedIndex;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: val,
                      borderRadius: BorderRadius.circular(6),
                      width: 22,
                      rodStackItems: [],
                      gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withAlpha(244), Theme.of(context).colorScheme.primary.withAlpha(180)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                      backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxY, color: Theme.of(context).colorScheme.primary.withAlpha(15)),
                    )
                  ],
                  showingTooltipIndicators: isTouched ? [0] : [],
                );
              }),
            ),
            // Use modern animation args
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
        }),
      ),
    );
  }
}
