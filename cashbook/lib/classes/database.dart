import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import '../global.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> deleteDatabases() async {
    final databasePath = join(await getDatabasesPath(), "ledger_db.db");
    if (await databaseExists(databasePath)) {
      await deleteDatabase(databasePath);
      _database = null;
      Global.log.t("Database deleted !");
    }
  }

  Future<Database> _initDatabase() async {
    Global.log.t("Database initialized!");
    final databasePath = join(await getDatabasesPath(), "ledger_db.db");
    return await openDatabase(databasePath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
        CREATE TABLE IF NOT EXISTS Ledger (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        cashBalance REAL NOT NULL,
        bankBalance REAL NOT NULL,
        notes TEXT);
      """);
    await db.execute(""" 
        CREATE TABLE IF NOT EXISTS Entity (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
        amount REAL NOT NULL,
        bank BOOLEAN NOT NULL,
        datetime DATETIME NOT NULL,
        notes TEXT,
        ledger_id INTEGER NOT NULL,
        account_id INTEGER NOT NULL,
        FOREIGN KEY(ledger_id) REFERENCES Ledger(id),
        FOREIGN KEY(account_id) REFERENCES Account(id));
      """);
    await db.execute(""" 
        CREATE TABLE IF NOT EXISTS Account (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        expenseAccount BOOLEAN NOT NULL,
        openingBalance REAL NOT NULL DEFAULT 0,
        currentBalance REAL NOT NULL DEFAULT 0,
        notes TEXT,
        ledger_id INTEGER NOT NULL,
        FOREIGN KEY(ledger_id) REFERENCES Ledger(id));
      """);
  }
}
