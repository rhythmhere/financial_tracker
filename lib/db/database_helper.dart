import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import '../models/saving.dart';
import '../models/investment.dart';
import '../models/liability.dart';
import '../models/profile.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('finance.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Profile
    await db.execute('''
      CREATE TABLE profile(
        name TEXT,
        currency TEXT
      )
    ''');

    // Expenses
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        amount REAL,
        date TEXT,
        notes TEXT
      )
    ''');

    // Savings
    await db.execute('''
      CREATE TABLE savings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        amount REAL,
        date TEXT,
        target REAL
      )
    ''');

    // Investments
    await db.execute('''
      CREATE TABLE investments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        name TEXT,
        buyPrice REAL,
        currentPrice REAL,
        quantity REAL,
        date TEXT
      )
    ''');

    // Liabilities
    await db.execute('''
      CREATE TABLE liabilities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        amount REAL,
        dueDate TEXT
      )
    ''');
  }

  // Profile CRUD (single row semantics)
  Future<void> upsertProfile(Profile profile) async {
    final db = await instance.database;
    // clear then insert to keep single row
    await db.delete('profile');
    await db.insert('profile', profile.toMap());
  }

  Future<Profile?> getProfile() async {
    final db = await instance.database;
    final res = await db.query('profile');
    if (res.isEmpty) return null;
    return Profile.fromMap(res.first);
  }

  // Expenses CRUD
  Future<int> insertExpense(Expense e) async {
    final db = await instance.database;
    return await db.insert('expenses', e.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await instance.database;
    final res = await db.query('expenses', orderBy: 'date DESC');
    return res.map((m) => Expense.fromMap(m)).toList();
  }

  Future<int> updateExpense(Expense e) async {
    final db = await instance.database;
    return await db.update('expenses', e.toMap(), where: 'id = ?', whereArgs: [e.id]);
  }

  Future<int> deleteExpense(int id) async {
    final db = await instance.database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Savings CRUD
  Future<int> insertSaving(Saving s) async {
    final db = await instance.database;
    return await db.insert('savings', s.toMap());
  }

  Future<List<Saving>> getSavings() async {
    final db = await instance.database;
    final res = await db.query('savings', orderBy: 'date DESC');
    return res.map((m) => Saving.fromMap(m)).toList();
  }

  Future<int> updateSaving(Saving s) async {
    final db = await instance.database;
    return await db.update('savings', s.toMap(), where: 'id = ?', whereArgs: [s.id]);
  }

  Future<int> deleteSaving(int id) async {
    final db = await instance.database;
    return await db.delete('savings', where: 'id = ?', whereArgs: [id]);
  }

  // Investments CRUD
  Future<int> insertInvestment(Investment i) async {
    final db = await instance.database;
    return await db.insert('investments', i.toMap());
  }

  Future<List<Investment>> getInvestments() async {
    final db = await instance.database;
    final res = await db.query('investments', orderBy: 'date DESC');
    return res.map((m) => Investment.fromMap(m)).toList();
  }

  Future<int> updateInvestment(Investment i) async {
    final db = await instance.database;
    return await db.update('investments', i.toMap(), where: 'id = ?', whereArgs: [i.id]);
  }

  Future<int> deleteInvestment(int id) async {
    final db = await instance.database;
    return await db.delete('investments', where: 'id = ?', whereArgs: [id]);
  }

  // Liabilities CRUD
  Future<int> insertLiability(Liability l) async {
    final db = await instance.database;
    return await db.insert('liabilities', l.toMap());
  }

  Future<List<Liability>> getLiabilities() async {
    final db = await instance.database;
    final res = await db.query('liabilities');
    return res.map((m) => Liability.fromMap(m)).toList();
  }

  Future<int> updateLiability(Liability l) async {
    final db = await instance.database;
    return await db.update('liabilities', l.toMap(), where: 'id = ?', whereArgs: [l.id]);
  }

  Future<int> deleteLiability(int id) async {
    final db = await instance.database;
    return await db.delete('liabilities', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
