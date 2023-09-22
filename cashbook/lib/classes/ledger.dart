import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class CashData {
  double earning = 0, expense = 0;
}

class Ledger {
  late Database _ledgerDB;
  late LedgerModel ledger;
  double expense = 0, earning = 0;
  Function(Ledger)? changeNotifier = null;
  void notify() {
    changeNotifier!(this);
  }

  void setChangeNotifier(Function(Ledger) fn) {
    changeNotifier = fn;
  }

  Future<CashData> totalMonth(DateTime from, DateTime to) async {
    List<EntityModel>? data = await getRecords(from, to);
    CashData month = CashData();
    if (data != null) {
      for (var element in data) {
        if (element.toAccount!.expenceAccount) {
          month.expense += element.amount;
        } else {
          month.earning += element.amount;
        }
      }
    }
    return month;
  }

  Future<List<EntityModel>?> getRecords(DateTime from, DateTime to) async {
    try {
      String sql = "select * from Entity where datetime between ? and ?";
      List<Map<String, dynamic>> maps = await _ledgerDB.rawQuery(sql,
          [from.toLocal().toIso8601String(), to.toLocal().toIso8601String()]);
      List<EntityModel> lst = [];
      for (var element in maps
          .map((e) async => await EntityModel.load(_ledgerDB, e['id']))) {
        if (await element == null) {
          continue;
        } else {
          lst.add((await element)!);
        }
      }
      return lst;
    } catch (err) {
      print("Recors date: " + err.toString());
      return null;
    }
  }

  static Future<Ledger?> load(int id) async {
    Ledger l = Ledger();
    await l.loadDatabases();
    await l.createTables(l._ledgerDB);
    LedgerModel? model = await LedgerModel.load(l._ledgerDB, 1);
    if (model == null) {
      l.ledger = const LedgerModel(
          id: 1, cashBalance: 0, bankBalance: 0, entitites: [], accounts: []);
      await l.createLedger(l.ledger);
    } else {
      l.ledger = model;
    }
    return l;
  }

  Future<bool> createLedger(LedgerModel model) async {
    try {
      await _ledgerDB.insert("Ledger", model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
      return true;
    } catch (err) {
      print("CREATE LEDGER : $err");
      return false;
    }
  }

  Future<int?> insertAccount(AccountModel account) async {
    try {
      if (account.openingBalance != 0 && account.currentBalance == 0) {
        account.currentBalance = account.openingBalance;
      }
      if (account.expenceAccount) {
        expense += account.currentBalance;
      } else {
        earning += account.currentBalance;
      }
      notify();
      return await _ledgerDB.insert("Account", account.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (err) {
      print("Account creation : $err");
      return null;
    }
  }

  Future<int?> insertEntity(EntityModel entity, LedgerModel ledger) async {
    try {
      int account_id = entity.toAccount!.id!;
      int entity_id = await _ledgerDB.insert("Entity", entity.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
      await _ledgerDB.insert(
          "EntityAccount", {'entity_id': entity_id, 'account_id': account_id},
          conflictAlgorithm: ConflictAlgorithm.abort);
      if (entity.toAccount!.expenceAccount) {
        expense += entity.amount;
      } else {
        earning += entity.amount;
      }
      notify();
      return entity_id;
    } catch (err) {
      print("ONE" + err.toString());
      return null;
    }
  }

  Future<bool> loadDatabases() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _ledgerDB = await openDatabase(
          join(await getDatabasesPath(), "ledger_db.db"),
          version: 2, onCreate: (db, version) async {
        await createTables(db);
      });
      return true;
    } catch (err) {
      print("Database open : $err");
      return false;
    }
  }

  Future<void> createTables(Database db) async {
    print("CREATING TABLES");
    try {
      await db.execute("DROP TABLE IF EXISTS Ledger");
      await db.execute("DROP TABLE IF EXISTS Entity");
      await db.execute("DROP TABLE IF EXISTS Account");
      await db.execute("DROP TABLE IF EXISTS LedgerEntity");
      await db.execute("DROP TABLE IF EXISTS LedgerAccount");
      await db.execute("DROP TABLE IF EXISTS EntityAccount");
      await db.execute("""
        CREATE TABLE Ledger (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        cashBalance REAL NOT NULL,
        bankBalance REAL NOT NULL,
        notes TEXT);
      """);
      await db.execute(""" 
        CREATE TABLE Entity (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
        amount REAL NOT NULL,
        bank BOOLEAN NOT NULL,
        datetime DATETIME NOT NULL,
        notes TEXT);
      """);
      await db.execute(""" 
        CREATE TABLE Account (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        expenseAccount BOOLEAN NOT NULL,
        openingBalance REAL NOT NULL DEFAULT 0,
        currentBalance REAL NOT NULL DEFAULT 0,
        notes TEXT);
      """);
      await db.execute(""" 
        CREATE TABLE LedgerEntity (
        ledger_id INTEGER NOT NULL,
        entity_id INTEGER NOT NULL,
        FOREIGN KEY(ledger_id) REFERENCES Ledger(id),
        FOREIGN KEY(entity_id) REFERENCES Entity(id));
      """);
      await db.execute(""" 
        CREATE TABLE LedgerAccount (
        account_id INTEGER NOT NULL,
        ledger_id INTEGER NOT NULL,
        FOREIGN KEY(account_id) REFERENCES Account(id),
        FOREIGN KEY(ledger_id) REFERENCES Ledger(id));
      """);
      await db.execute(""" 
        CREATE TABLE EntityAccount (
        account_id INTEGER NOT NULL,
        entity_id INTEGER NOT NULL,
        FOREIGN KEY(account_id) REFERENCES Account(id),
        FOREIGN KEY(entity_id) REFERENCES Entity(id));
      """);
    } catch (err) {
      print("Create : $err");
    }
  }

  static List<DateTime> getMonthRange(DateTime day) {
    List<DateTime> d = [
      day.copyWith(hour: 0, minute: 0, day: 1),
      day.copyWith(
          hour: 0, minute: 0, day: 1, month: (DateTime.now().month + 1) % 12)
    ];
    return d;
  }

  Database getDatabase() {
    return _ledgerDB;
  }
}

// Database models
class LedgerModel {
  final int id;
  final double cashBalance;
  final double bankBalance;
  final List<EntityModel> entitites;
  final List<AccountModel> accounts;
  final String? notes;
  const LedgerModel(
      {required this.id,
      required this.cashBalance,
      required this.bankBalance,
      required this.entitites,
      required this.accounts,
      this.notes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cashBalance': cashBalance,
      'bankBalance': bankBalance,
      'notes': notes
    };
  }

  static Future<LedgerModel?> load(Database db, int id) async {
    try {
      LedgerModel l;
      final List<Map<String, dynamic>> maps =
          await db.query("Ledger", where: "id=?", whereArgs: [id]);
      List<LedgerModel> list = List.generate(maps.length, (i) {
        return LedgerModel(
            id: maps[i]['id'],
            cashBalance: maps[i]['cashBalance'],
            bankBalance: maps[i]['bankBalance'],
            entitites: maps[i]['entitites'],
            accounts: maps[i]['accounts']);
      });
      if (list.isNotEmpty) {
        l = list[0];
        return l;
      } else {
        return null;
      }
    } catch (err) {
      print("Ledger model load : $err");
    }
  }
}

class EntityModel {
  final int? id;
  final double amount;
  final bool bank;
  final AccountModel? toAccount;
  final DateTime datetime;
  final String? notes;

  const EntityModel(
      {required this.id,
      required this.amount,
      required this.bank,
      required this.toAccount,
      required this.datetime,
      this.notes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'bank': bank,
      'datetime': datetime.toIso8601String(),
      'notes': notes
    };
  }

  static Future<EntityModel?> load(Database db, int id) async {
    try {
      EntityModel model;
      List<Map<String, dynamic>> m =
          await db.rawQuery("select * from Entity where id=?", [id]);
      if (m.isEmpty) {
        print("Empty record");
        return null;
      }
      List<Map<String, dynamic>> am = await db
          .rawQuery("select * from EntityAccount where entity_id=?", [id]);
      if (am.isEmpty) {
        print("Empty account data");
        return null;
      }

      model = EntityModel(
          id: m[0]['id'],
          amount: m[0]['amount'],
          bank: m[0]['bank'] == 0 ? false : true,
          toAccount: await AccountModel.load(db, am[0]['account_id']),
          datetime: DateTime.parse(m[0]['datetime']));
      return model;
    } catch (err) {
      print("Entity model load : $err");
      return null;
    }
  }
}

class AccountModel {
  int? id;
  String name;
  bool expenceAccount;
  double openingBalance;
  double currentBalance;
  String? notes;
  AccountModel(
      {required this.id,
      required this.name,
      required this.expenceAccount,
      required this.openingBalance,
      required this.currentBalance,
      this.notes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'expenseAccount': expenceAccount,
      'openingBalance': openingBalance,
      'currentBalance': currentBalance,
      'notes': notes
    };
  }

  static Future<AccountModel?> load(Database db, int id) async {
    try {
      AccountModel model;
      List<Map<String, dynamic>> m =
          await db.rawQuery("select * from Account where id=?", [id]);
      if (m.isEmpty) {
        print("Empty record");
        return null;
      }
      // print(m);
      model = AccountModel(
          id: m[0]['id'],
          name: m[0]['name'],
          expenceAccount: m[0]['expenseAccount'] == 0 ? false : true,
          openingBalance: m[0]['openingBalance'],
          currentBalance: m[0]['currentBalance']);
      return model;
    } catch (err) {
      print("Account Model Load : $err");
      return null;
    }
  }

  Future<List<EntityModel>?> getStatment(
      Database db, DateTime from, DateTime to) async {
    try {
      CashData data = CashData();
      List<Map<String, dynamic>> m = await db
          .rawQuery("select * from EntityAccount where account_id=?", [id]);
      List<EntityModel> ens = [];
      for (var element in m) {
        var e_id = element['entity_id'];
        List<Map<String, dynamic>> edata = await db.rawQuery(
            "select * from Entity where id=? and datetime between ? and ?", [
          e_id,
          from.toLocal().toIso8601String(),
          to.toLocal().toIso8601String()
        ]);
        if (edata.isEmpty) {
          continue;
        } else {
          ens.add(EntityModel(
              id: edata[0]['id'],
              amount: edata[0]['amount'],
              bank: edata[0]['bank'] == 0 ? false : true,
              toAccount: this,
              datetime: DateTime.parse(edata[0]['datetime'])));
        }
      }
      return ens;
    } catch (err) {
      print("GET ACCOUNT STATMENT : $err");
      return null;
    }
  }
}
