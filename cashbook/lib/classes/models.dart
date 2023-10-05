import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../global.dart';

class AccountTypes {
  static String earning = "earning";
  static String expense = "expense";
  static String savings = "savings";
}

class CashData {
  double earning = 0, expense = 0, savings = 0;
}

class AccountStatment {
  DateTime from;
  DateTime to;
  AccountModel account;
  double balance;
  List<EntityModel> received;
  List<EntityModel> send;
  double totalSend;
  double totalReceived;
  AccountStatment({
    required this.from,
    required this.to,
    required this.received,
    required this.send,
    required this.balance,
    required this.account,
    required this.totalReceived,
    required this.totalSend,
  });
}

// Database models
class LedgerModel extends Model {
  @override
  String modelName = "Ledger";
  final int id;
  final double cashBalance;
  final double bankBalance;
  final List<EntityModel> entitites;
  final List<AccountModel> accounts;
  final String? notes;
  LedgerModel(
      {required super.db,
      required this.id,
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

  @override
  Future<int?> insert() async {
    try {
      return await db.insert("Ledger", toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (e) {
      print("Insert Ledger : $e");
      return null;
    }
  }

  @override
  Future<bool> update() async {
    try {
      Map<String, dynamic> data = toMap();
      data.remove("id");
      await db.update("Ledger", data,
          where: "id=?",
          whereArgs: [id],
          conflictAlgorithm: ConflictAlgorithm.abort);
      return true;
    } catch (e) {
      print("Update ledger : $e");
      return false;
    }
  }

  @override
  Future<bool> delete() async {
    try {
      await db.delete("Ledger", where: "id=?", whereArgs: [id]);
      return true;
    } catch (e) {
      print("Delete : $e");
      return false;
    }
  }

  static Future<LedgerModel?> get(Database db, int id) async {
    List<Map<String, dynamic>> res =
        await db.query("Ledger", where: "id=?", whereArgs: [id]);
    if (res.isEmpty) {
      return null;
    } else {
      return LedgerModel(
          db: db,
          id: id,
          cashBalance: res[0]['cashBalance'],
          bankBalance: res[0]['bankBalance'],
          entitites: await EntityModel.all(db),
          accounts: await AccountModel.all(db));
    }
  }

  static Future<List<LedgerModel>> loadData(
      Database db, List<Map<String, dynamic>> data) async {
    List<LedgerModel> d = [];
    for (var res in data) {
      d.add(LedgerModel(
          db: db,
          id: res['id'],
          cashBalance: res['cashBalance'],
          bankBalance: res['bankBalance'],
          entitites: await EntityModel.all(db),
          accounts: await AccountModel.all(db)));
    }
    return d;
  }
}

class EntityModel extends Model {
  @override
  String modelName = "Entity";
  final int? id;
  final double amount;
  final AccountModel fromAccount;
  final AccountModel toAccount;
  final DateTime datetime;
  final String? notes;
  final int ledgerId;
  EntityModel(
      {required super.db,
      required this.id,
      required this.amount,
      required this.fromAccount,
      required this.toAccount,
      required this.datetime,
      required this.ledgerId,
      this.notes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'fromAccount': fromAccount.id,
      'datetime': datetime.toIso8601String(),
      'notes': notes,
      'ledger_id': ledgerId,
      'toAccount': toAccount.id
    };
  }

  @override
  Future<int?> insert() async {
    try {
      return await db.insert("Entity", toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort); // Insert a new entity
    } catch (e) {
      print("Insert Ledger : $e");
      return null;
    }
  }

  @override
  Future<bool> update() async {
    try {
      Map<String, dynamic> data = toMap();
      data.remove("id");
      await db.update("Entity", data,
          where: "id=?",
          whereArgs: [id],
          conflictAlgorithm: ConflictAlgorithm.abort); // update record
      return true;
    } catch (e) {
      print("Update ledger : $e");
      return false;
    }
  }

  @override
  Future<bool> delete() async {
    try {
      await db
          .delete("Entity", where: "id=?", whereArgs: [id]); // delete record
      return true;
    } catch (e) {
      print("Delete : $e");
      return false;
    }
  }

  static Future<EntityModel?> get(Database db, int id) async {
    List<Map<String, dynamic>> res =
        await db.query("Entity", where: "id=?", whereArgs: [id]);
    if (res.isEmpty) {
      return null;
    } else {
      return EntityModel(
          db: db,
          id: id,
          amount: res[0]['amount'],
          fromAccount: (await AccountModel.get(db, res[0]['fromAccount']))!,
          toAccount: (await AccountModel.get(db, res[0]['toAccount']))!,
          datetime: DateTime.parse(res[0]['datetime']),
          ledgerId: res[0]['ledger_id']);
    }
  }

  static Future<List<EntityModel>> all(Database db) async {
    List<Map<String, dynamic>> res = await db.query("Entity");
    List<EntityModel> e = [];
    if (res.isEmpty) {
      return e;
    } else {
      for (var r in res) {
        e.add(EntityModel(
            db: db,
            id: r['id'],
            amount: r['amount'],
            fromAccount: (await AccountModel.get(db, r['fromAccount']))!,
            toAccount: (await AccountModel.get(db, r['toAccount']))!,
            datetime: DateTime.parse(r['datetime']),
            ledgerId: r['ledger_id']));
      }
      return e;
    }
  }

  static Future<List<EntityModel>> loadData(
      Database db, List<Map<String, dynamic>> data) async {
    List<EntityModel> d = [];
    for (var res in data) {
      d.add(EntityModel(
          db: db,
          id: res['id'],
          amount: res['amount'],
          fromAccount: (await AccountModel.get(db, res['fromAccount']))!,
          toAccount: (await AccountModel.get(db, res['toAccount']))!,
          datetime: DateTime.parse(res['datetime']),
          ledgerId: res['ledger_id']));
    }
    return d;
  }
}

class AccountModel extends Model {
  @override
  String modelName = "Account";
  int? id;
  String name;
  String type;
  double openingBalance;
  DateTime openingDate;
  double currentBalance;
  Color color;
  String? notes;
  int ledgerId;
  AccountModel(
      {required super.db,
      required this.id,
      required this.name,
      required this.type,
      required this.openingBalance,
      required this.openingDate,
      required this.currentBalance,
      required this.ledgerId,
      required this.color,
      this.notes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'openingBalance': openingBalance,
      'currentBalance': currentBalance,
      'openingDate': openingDate.toIso8601String(),
      'color': color.value,
      'notes': notes,
      'ledger_id': ledgerId
    };
  }

  @override
  Future<int?> insert() async {
    try {
      return await db.insert("Account", toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort); // Insert a new account
    } catch (e) {
      print("Insert Ledger : $e");
      return null;
    }
  }

  @override
  Future<bool> update() async {
    try {
      Map<String, dynamic> data = toMap();
      data.remove("id");
      await db.update("Account", data,
          where: "id=?",
          whereArgs: [id],
          conflictAlgorithm: ConflictAlgorithm.abort); // update record
      return true;
    } catch (e) {
      print("Update ledger : $e");
      return false;
    }
  }

  @override
  Future<bool> delete() async {
    try {
      await db
          .delete("Account", where: "id=?", whereArgs: [id]); // delete record
      return true;
    } catch (e) {
      print("Delete : $e");
      return false;
    }
  }

  static Future<List<AccountModel>> getOfType(
      Database db, List<String> type) async {
    List<Map<String, dynamic>> res = [];
    for (var i in type) {
      res.addAll(await db.query("Account", where: "type=?", whereArgs: [i]));
    }
    return loadData(db, res);
  }

  static Future<AccountModel?> get(Database db, int id) async {
    List<Map<String, dynamic>> res =
        await db.query("Account", where: "id=?", whereArgs: [id]);
    if (res.isEmpty) {
      return null;
    } else {
      return AccountModel(
          db: db,
          id: id,
          name: res[0]['name'],
          type: res[0]['type'],
          openingBalance: res[0]['openingBalance'],
          openingDate: DateTime.parse(res[0]['openingDate']),
          currentBalance: res[0]['currentBalance'],
          notes: res[0]['notes'],
          color: Color(res[0]['color']),
          ledgerId: res[0]['ledger_id']);
    }
  }

  static Future<List<AccountModel>> all(Database db) async {
    List<Map<String, dynamic>> res = await db.query("Account");
    if (res.isEmpty) {
      return [];
    } else {
      List<AccountModel> e = [];
      for (var r in res) {
        e.add(AccountModel(
            db: db,
            id: r['id'],
            name: r['name'],
            type: r['type'],
            openingBalance: r['openingBalance'],
            openingDate: DateTime.parse(r['openingDate']),
            currentBalance: r['currentBalance'],
            notes: r['notes'],
            color: Color(r['color']),
            ledgerId: r['ledger_id']));
      }
      return e;
    }
  }

  static Future<List<AccountModel>> loadData(
      Database db, List<Map<String, dynamic>> data) async {
    List<AccountModel> d = [];
    for (var res in data) {
      d.add(AccountModel(
          db: db,
          id: res['id'],
          name: res['name'],
          type: res['type'],
          openingBalance: res['openingBalance'],
          openingDate: DateTime.parse(res['openingDate']),
          currentBalance: res['currentBalance'],
          notes: res['notes'],
          color: Color(res['color']),
          ledgerId: res['ledger_id']));
    }
    return d;
  }

  Future<AccountStatment?> getStatment(
      Database db, DateTime from, DateTime to) async {
    try {
      List<EntityModel> received = [];
      List<EntityModel> sended = [];
      double receivedBal = 0;
      double sendBal = 0;

      List<Map<String, dynamic>> receivedData = await db.rawQuery(
          "select * from Entity where toAccount=? and datetime between ? and ?",
          [
            id,
            from.toLocal().toIso8601String(),
            to.toLocal().toIso8601String()
          ]);
      List<Map<String, dynamic>> sendData = await db.rawQuery(
          "select * from Entity where fromAccount=? and datetime between ? and ?",
          [
            id,
            from.toLocal().toIso8601String(),
            to.toLocal().toIso8601String()
          ]);
      for (var element in receivedData) {
        receivedBal += element['amount'];
        received.add(EntityModel(
            db: db,
            id: element['id'],
            amount: element['amount'],
            fromAccount: (await AccountModel.get(db, element['fromAccount']))!,
            toAccount: this,
            datetime: DateTime.parse(element['datetime']),
            ledgerId: element['ledger_id']));
      }
      for (var element in sendData) {
        sendBal += element['amount'];
        sended.add(EntityModel(
            db: db,
            id: element['id'],
            amount: element['amount'],
            fromAccount: (await AccountModel.get(db, element['fromAccount']))!,
            toAccount: this,
            datetime: DateTime.parse(element['datetime']),
            ledgerId: element['ledger_id']));
      }
      // after date substraction
      List<Map<String, dynamic>> receivedDataAfter = await db.rawQuery(
          "select * from Entity where toAccount=? and datetime > ?",
          [id, to.toLocal().toIso8601String()]);
      List<Map<String, dynamic>> sendDataAfter = await db.rawQuery(
          "select * from Entity where fromAccount=? and datetime > ?",
          [id, to.toLocal().toIso8601String()]);
      double recAfter = 0, sendAfter = 0;
      if (receivedDataAfter.isNotEmpty) {
        for (var i in receivedDataAfter) {
          recAfter += i['amount'];
        }
      }
      if (sendDataAfter.isNotEmpty) {
        for (var i in sendDataAfter) {
          sendAfter += i['amount'];
        }
      }
      double balance = currentBalance - (recAfter - sendAfter);
      return AccountStatment(
          from: from,
          to: to,
          received: received,
          send: sended,
          balance: balance,
          account: this,
          totalReceived: receivedBal,
          totalSend: sendBal);
    } catch (err) {
      print("GET ACCOUNT STATMENT : $err");
      return null;
    }
  }
}

abstract class Model {
  Database db;
  String modelName = "";
  Model({required this.db});
  Future<int?> insert();
  Future<bool> delete();
  Future<bool> update();
  Map<String, dynamic> toMap();
  @override
  String toString() {
    // TODO: implement toString
    return "<$modelName> " + toMap().toString() + "\n";
  }
  // Future<List<Model>> all();
}
