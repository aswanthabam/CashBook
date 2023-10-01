import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import 'database.dart';
import 'models.dart';

class Ledger {
  static final Ledger _instance = Ledger._internal();
  factory Ledger() => _instance;
  Ledger._internal();

  static late Database _database;
  late LedgerModel ledger;

  double expense = 0, earning = 0, savings = 0;
  Map<String, Function(Ledger)> changeNotifier = {};
  late Future<bool> loaded;
  bool is_loaded = false;
  Future<bool>? creatingTables;
  /* ----------------- INTITIALIZATIION / LOAD FUNCTIONS --------------- */
  // Function to initialize the ledger
  bool load(int id) {
    try {
      loaded = _load2(id);
      loaded.then((value) {
        is_loaded = value;
      });
      return true;
    } catch (err) {
      Global.log.e("Error occured while loading ledger : $err");
      return false;
    }
  }

  // Function that runs when initializing the ledger
  Future<bool> _load2(int id) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final dbHelper = DatabaseHelper();
      _database = await dbHelper.database; // Load the databas
      LedgerModel? model =
          await LedgerModel.get(_database, 1); // Try to get the default ledger
      if (model == null) {
        // create ledger if not exists
        ledger = LedgerModel(
            db: _database,
            id: 1,
            cashBalance: 0,
            bankBalance: 0,
            entitites: [],
            accounts: []);
        await ledger.insert(); // insert ledger
      } else {
        // load data from the previous ledger created
        ledger = model;
        for (var acc in ledger.accounts) {
          print(acc.toMap());
          if (acc.type == "expense") {
            expense += acc.currentBalance;
          } else if (acc.type == "earning") {
            // -------------------- NEED CHANGE
            earning += acc.currentBalance;
          } else {
            savings += acc.currentBalance;
          }
        }
      }
      Global.log.t("""Loaded Ledger:\n
  expense : $expense
  earning : $earning
  savings : $savings
  Ledger : $ledger
  Accounts :
    ${ledger.accounts.toString().replaceAll("[", "").replaceAll(']', '')}""");
      notify();
      return true;
    } catch (err) {
      Global.log.e("Error while loading ledger (2): $err");
      return false;
    }
  }

  /* ----------------- DATA STATISTICS FUNCTIONS --------------- */
  // get the total amount for the month
  Future<CashData> totalMonth(DateTime from, DateTime to) async {
    List<EntityModel>? data = await getRecords(from, to);
    CashData month = CashData();
    if (data != null) {
      for (var element in data) {
        if (element.toAccount.type == "expense") {
          month.expense += element.amount;
        } else if (element.toAccount.type == "earning") {
          month.earning += element.amount;
          Global.log.f("Rare condition : toAccout Earning");
        } else {
          month.savings += element.amount;
        }
        if (element.fromAccount.type == "earning") {
          month.earning += element.amount;
        }
      }
    }
    Global.log.t(
        "Calculated total month Total\nTotal records in time period : ${data!.length}\nEarnings : ${month.earning}\nExpense : ${month.expense}\nSavings: ${month.savings}");
    return month;
  }

  // get records in a given date range
  Future<List<EntityModel>?> getRecords(DateTime from, DateTime to) async {
    if (!await loaded) {
      // Do the error handling of unloaded ledger
      Global.log.w("Unimplemented handler : getRecords : loaded");
    }
    try {
      String sql = "select * from Entity where datetime between ? and ?";
      List<Map<String, dynamic>> maps = await _database.rawQuery(sql,
          [from.toLocal().toIso8601String(), to.toLocal().toIso8601String()]);
      List<EntityModel> lst = await EntityModel.loadData(_database, maps);
      return lst;
    } catch (err) {
      Global.log.e("Error while geting records in given date range : $err");
      return null;
    }
  }

  /* ----------------- DATA MODIFICATION FUNCTIONS --------------- */
  Future<int?> insertAccount(AccountModel account) async {
    if (!await loaded) {
      // Do the error handling of unloaded ledger
      Global.log.w("Ledger not loaded : insertAccount : loaded");
      return null;
    }
    try {
      if (account.openingBalance != 0 && account.currentBalance == 0) {
        account.currentBalance = account.openingBalance;
      }
      if (account.type == "expense") {
        expense += account.currentBalance;
      } else if (account.type == "earning") {
        earning += account.currentBalance;
      } else {
        savings += account.currentBalance;
      }
      int? l = await account.insert();
      Global.log.t("Created Account : $account");
      notify();
      return l;
    } catch (err) {
      Global.log.e("Error while inserting account : $err");
      return null;
    }
  }

  Future<int?> insertEntity(EntityModel entity) async {
    if (!await loaded) {
      // Do the error handling of unloaded ledger
      Global.log.w("Ledger not loaded : insertEntity : loaded");
    }
    try {
      if (entity.toAccount.type == "expense") {
        expense += entity.amount;
        if (entity.fromAccount.type == "savings") {
          savings -= entity.amount; // debit amount from savings
        }
      } else if (entity.toAccount.type == "earning") {
        earning += entity.amount;
        Global.log.f("""A rare condition occured:
        Received to an earning account
        $entity
        fromaccount:${entity.fromAccount}
        toaccount:${entity.toAccount}
        This may cause huge error in future""");
      } else {
        if (entity.fromAccount.type != "savings") {
          savings += entity.amount; // dont want to do twise
        }
      }
      entity.toAccount.currentBalance += entity.amount;

      if (entity.fromAccount.type == "earning") {
        entity.fromAccount.currentBalance += entity
            .amount; // in case of receive from earning,want to add the amount to current balance
        earning += entity.amount;
      } else {
        entity.fromAccount.currentBalance -= entity.amount;
      }
      Global.log.t("""Adding a new entity (type : ${entity.toAccount.type})
          to : ${entity.toAccount.name}
          amount : ${entity.amount}
          Entity : $entity
          from account : ${entity.fromAccount}
          to account : ${entity.toAccount}""");
      int? l = await entity.insert();
      await entity.fromAccount.update();
      await entity.toAccount.update();
      notify();
      return l;
    } catch (err) {
      Global.log.e("Error inseting entity : $err");
      return null;
    }
  }

  /* ----------------- UTILITY FUNCTIONS --------------- */
  void notify() {
    changeNotifier.forEach((key, value) {
      value(this);
    });
  }

  // bind a function to call when some change occured
  //  any class can add a change notifier to Ledger
  void setChangeNotifier(Function(Ledger) fn, String id) {
    changeNotifier[id] = fn;
  }

  void removeChangeNotifier(String id) {
    changeNotifier.remove(id);
  }

  /* ----------------- STATIC UTILITY FUNCTIONS --------------- */
  static List<DateTime> getMonthRange(DateTime day) {
    List<DateTime> d = [
      day.copyWith(hour: 0, minute: 0, day: 1),
      day.copyWith(
          hour: 0, minute: 0, day: 1, month: (DateTime.now().month + 1) % 12)
    ];
    return d;
  }

  Database getDatabase() {
    return _database;
  }
}
