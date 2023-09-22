import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Ledger {
  late Database _ledgerDB;
  late Database _accountDB;
  late Database _entityDB;
  Ledger() {
    loadDatabases().then((value) {});
  }

  Future<bool> loadDatabases() async {
    try {
      _ledgerDB =
          await openDatabase(join(await getDatabasesPath(), "ledger_db.db"));
      _accountDB =
          await openDatabase(join(await getDatabasesPath(), "account_db.db"));
      _entityDB =
          await openDatabase(join(await getDatabasesPath(), "entity_db.db"));
      return true;
    } catch (err) {
      return false;
    }
  }
}

// Database models
class LedgerModel {
  final String id;
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
      'entities': entitites.map((e) => e.toMap()),
      'accounts': accounts.map((e) => e.toMap()),
      'notes': notes
    };
  }
}

class EntityModel {
  final String id;
  final double amount;
  final bool bank;
  final AccountModel toAccount;
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
      'toAccount': toAccount.toMap(),
      'datetime': datetime,
      'notes': notes
    };
  }
}

class AccountModel {
  String id;
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
      'expenceAccount': expenceAccount,
      'openingBalance': openingBalance,
      'currentBalance': currentBalance,
      'notes': notes
    };
  }
}
