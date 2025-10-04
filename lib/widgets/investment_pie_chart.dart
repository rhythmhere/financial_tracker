import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';

class InvestmentPieChart extends StatefulWidget {
  final Map<String, double> data; // type -> value
  const InvestmentPieChart({super.key, required this.data});

  @override
  State<InvestmentPieChart> createState() => _InvestmentPieChartState();
}

class _InvestmentPieChartState extends State<InvestmentPieChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final entries = widget.data.entries.toList();
    final total = entries.fold<double>(0, (a, b) => a + b.value);
    if (entries.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(child: Text('No investments to display', style: Theme.of(context).textTheme.bodyLarge)),
      );
    }

    return SizedBox(
      height: 220,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 6,
                centerSpaceRadius: 36,
                sections: List.generate(entries.length, (i) {
                  final e = entries[i];
                  final isTouched = i == _touchedIndex;
                  final percent = total > 0 ? (e.value / total) * 100 : 0;
                  return PieChartSectionData(
                    value: e.value,
                    title: isTouched ? '${percent.toStringAsFixed(1)}%' : '',
                    radius: isTouched ? 60 : 48,
                    titleStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    color: Color.lerp(
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      i / (entries.length + 1),
                    )?.withAlpha(244),
                    badgeWidget: isTouched
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withAlpha(230),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${e.key}: \$${e.value.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : null,
                    badgePositionPercentageOffset: .98,
                  );
                }),
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
                    setState(() {
                      final idx =
                          pieTouchResponse?.touchedSection?.touchedSectionIndex;
                      _touchedIndex = idx;
                    });
                  },
                ),
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final e = entries[index];
                final percent = total > 0 ? (e.value / total) * 100 : 0;
                return ListTile(
                  title: Text(
                    e.key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '${percent.toStringAsFixed(1)}%',
                    style: TextStyle(color: kPrimary),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
