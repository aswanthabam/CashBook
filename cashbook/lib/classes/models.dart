import 'package:sqflite/sqflite.dart';
import '../global.dart';

class CashData {
  double earning = 0, expense = 0;
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
  final bool bank;
  final AccountModel toAccount;
  final DateTime datetime;
  final String? notes;
  final int ledgerId;
  final int accountId;
  EntityModel(
      {required super.db,
      required this.id,
      required this.amount,
      required this.bank,
      required this.toAccount,
      required this.datetime,
      required this.ledgerId,
      required this.accountId,
      this.notes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'bank': bank,
      'datetime': datetime.toIso8601String(),
      'notes': notes,
      'ledger_id': ledgerId,
      'account_id': accountId
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
          bank: res[0]['bank'] == 0 ? false : true,
          toAccount: (await AccountModel.get(db, res[0]['account_id']))!,
          datetime: DateTime.parse(res[0]['datetime']),
          ledgerId: res[0]['ledger_id'],
          accountId: res[0]['account_id']);
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
            bank: r['bank'] == 0 ? false : true,
            toAccount: (await AccountModel.get(db, r['account_id']))!,
            datetime: DateTime.parse(r['datetime']),
            ledgerId: r['ledger_id'],
            accountId: r['account_id']));
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
          bank: res['bank'] == 0 ? false : true,
          toAccount: (await AccountModel.get(db, res['account_id']))!,
          datetime: DateTime.parse(res['datetime']),
          ledgerId: res['ledger_id'],
          accountId: res['account_id']));
    }
    return d;
  }
}

class AccountModel extends Model {
  @override
  String modelName = "Account";
  int? id;
  String name;
  bool expenseAccount;
  double openingBalance;
  double currentBalance;
  String? notes;
  int ledgerId;
  AccountModel(
      {required super.db,
      required this.id,
      required this.name,
      required this.expenseAccount,
      required this.openingBalance,
      required this.currentBalance,
      required this.ledgerId,
      this.notes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'expenseAccount': expenseAccount,
      'openingBalance': openingBalance,
      'currentBalance': currentBalance,
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
          expenseAccount: res[0]['expenseAccount'] == 0 ? false : true,
          openingBalance: res[0]['openingBalance'],
          currentBalance: res[0]['currentBalance'],
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
            expenseAccount: r['expenseAccount'] == 0 ? false : true,
            openingBalance: r['openingBalance'],
            currentBalance: r['currentBalance'],
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
          expenseAccount: res['expenseAccount'] == 0 ? false : true,
          openingBalance: res['openingBalance'],
          currentBalance: res['currentBalance'],
          ledgerId: res['ledger_id']));
    }
    return d;
  }

  Future<List<EntityModel>?> getStatment(
      Database db, DateTime from, DateTime to) async {
    try {
      CashData data = CashData();
      List<Map<String, dynamic>> m = await db.rawQuery(
          "select * from Entity where account_id=? and datetime between ? and ?",
          [
            id,
            from.toLocal().toIso8601String(),
            to.toLocal().toIso8601String()
          ]);
      List<EntityModel> ens = [];
      for (var element in m) {
        ens.add(EntityModel(
            db: db,
            id: element['id'],
            amount: element['amount'],
            bank: element['bank'] == 0 ? false : true,
            toAccount: this,
            datetime: DateTime.parse(element['datetime']),
            ledgerId: element['ledger_id'],
            accountId: element['account_id']));
      }
      return ens;
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
