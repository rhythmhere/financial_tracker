import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/expense.dart';
import '../models/saving.dart';
import '../models/investment.dart';
import '../models/liability.dart';
import '../models/profile.dart';

class AppState extends ChangeNotifier {
  final db = DatabaseHelper.instance;

  Profile? profile;
  List<Expense> expenses = [];
  List<Saving> savings = [];
  List<Investment> investments = [];
  List<Liability> liabilities = [];

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    profile = await db.getProfile();
    expenses = await db.getExpenses();
    savings = await db.getSavings();
    investments = await db.getInvestments();
    liabilities = await db.getLiabilities();
    notifyListeners();
  }

  // Profile
  Future<void> upsertProfile(Profile p) async {
    await db.upsertProfile(p);
    profile = p;
    notifyListeners();
  }

  // Expenses
  Future<void> addExpense(Expense e) async {
    await db.insertExpense(e);
    expenses = await db.getExpenses();
    notifyListeners();
  }

  Future<void> updateExpense(Expense e) async {
    await db.updateExpense(e);
    expenses = await db.getExpenses();
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    await db.deleteExpense(id);
    expenses = await db.getExpenses();
    notifyListeners();
  }

  // Savings
  Future<void> addSaving(Saving s) async {
    await db.insertSaving(s);
    savings = await db.getSavings();
    notifyListeners();
  }

  Future<void> updateSaving(Saving s) async {
    await db.updateSaving(s);
    savings = await db.getSavings();
    notifyListeners();
  }

  Future<void> deleteSaving(int id) async {
    await db.deleteSaving(id);
    savings = await db.getSavings();
    notifyListeners();
  }

  // Investments
  Future<void> addInvestment(Investment i) async {
    await db.insertInvestment(i);
    investments = await db.getInvestments();
    notifyListeners();
  }

  Future<void> updateInvestment(Investment i) async {
    await db.updateInvestment(i);
    investments = await db.getInvestments();
    notifyListeners();
  }

  Future<void> deleteInvestment(int id) async {
    await db.deleteInvestment(id);
    investments = await db.getInvestments();
    notifyListeners();
  }

  // Liabilities
  Future<void> addLiability(Liability l) async {
    await db.insertLiability(l);
    liabilities = await db.getLiabilities();
    notifyListeners();
  }

  Future<void> updateLiability(Liability l) async {
    await db.updateLiability(l);
    liabilities = await db.getLiabilities();
    notifyListeners();
  }

  Future<void> deleteLiability(int id) async {
    await db.deleteLiability(id);
    liabilities = await db.getLiabilities();
    notifyListeners();
  }

  // Calculations
  double get totalSavings => savings.fold(0.0, (p, e) => p + e.amount);

  double get totalInvestmentsValue => investments.fold(0.0, (p, e) => p + (e.currentPrice * e.quantity));

  double get totalLiabilities => liabilities.fold(0.0, (p, e) => p + e.amount);

  double get netWorth => totalSavings + totalInvestmentsValue - totalLiabilities;

  double monthlyExpensesSummary(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final list = expenses.where((e) {
      final d = DateTime.parse(e.date);
      return d.isAfter(start.subtract(const Duration(seconds: 1))) && d.isBefore(end);
    });
    return list.fold(0.0, (p, e) => p + e.amount);
  }

  Map<String, double> expensesByCategoryForMonth(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final list = expenses.where((e) {
      final d = DateTime.parse(e.date);
      return d.isAfter(start.subtract(const Duration(seconds: 1))) && d.isBefore(end);
    });
    final Map<String, double> map = {};
    for (var e in list) {
      map[e.category] = (map[e.category] ?? 0.0) + e.amount;
    }
    return map;
  }

  Map<String, double> investmentAllocationByType() {
    final Map<String, double> map = {};
    for (var i in investments) {
      final v = i.currentPrice * i.quantity;
      map[i.type] = (map[i.type] ?? 0.0) + v;
    }
    return map;
  }

  // Simple streak: consecutive days with at least one expense logged
  int get dailyLoggingStreak {
    if (expenses.isEmpty) return 0;
    final dates = expenses.map((e) => DateTime.parse(e.date).toUtc().toIso8601String().split('T').first).toSet();
    int streak = 0;
    DateTime day = DateTime.now();
    while (true) {
      final key = day.toUtc().toIso8601String().split('T').first;
      if (dates.contains(key)) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}
