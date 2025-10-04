import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/dashboard_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/investments_screen.dart';
import 'screens/savings_screen.dart';
import 'screens/liabilities_screen.dart';
import 'screens/profile_screen.dart';
import 'theme.dart';

// Helper: Floating Bottom Navigation
class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const FloatingBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: PhysicalModel(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 70,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: Theme.of(context).colorScheme.surface),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (i) {
              final icons = [Icons.show_chart, Icons.receipt_long, Icons.pie_chart, Icons.savings, Icons.money_off];
              final labels = ['Dashboard', 'Expenses', 'Investments', 'Savings', 'Liabilities'];
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: selected ? kPrimary.withAlpha(30) : Colors.transparent, borderRadius: BorderRadius.circular(16)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(icons[i], color: selected ? const Color(0xFF00BFA5) : const Color(0xFFB0B0B0)),
                    const SizedBox(height: 4),
                    Text(labels[i], style: TextStyle(fontSize: 11, color: selected ? const Color(0xFF00BFA5) : const Color(0xFFB0B0B0))),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initialize(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: const HomeShell(),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardScreen(),
    ExpensesScreen(),
    InvestmentsScreen(),
    SavingsScreen(),
    LiabilitiesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(app.profile?.name ?? 'Finance', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'Raleway')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: softShadows(greenish: true), border: Border.all(color: kPrimary.withAlpha(46))),
                child: Builder(builder: (context) {
                    final n = app.profile?.name ?? '';
                    // Prefer a packaged logo if present, otherwise show initial
                    return FutureBuilder<bool>(
                      future: Future.value(true), // placeholder to allow synchronous asset image usage fallback
                      builder: (ctx, snap) {
                        // Try using AssetImage directly; Flutter will show broken image if not present, so we guard by displaying Image.asset in a ClipOval.
                        try {
                          return ClipOval(
                            child: Image.asset('assets/images/applogo.png', fit: BoxFit.cover, width: 40, height: 40),
                          );
                        } catch (_) {
                          return CircleAvatar(backgroundColor: kPrimary, child: Text(n.isNotEmpty ? n[0].toUpperCase() : 'U'));
                        }
                      },
                    );
                }),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: SafeArea(child: FloatingBottomNav(currentIndex: _index, onTap: (i) => setState(() => _index = i))),
    );
  }
}
