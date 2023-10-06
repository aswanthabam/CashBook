import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import 'database.dart';
import 'models.dart';
import 'package:flutter/material.dart';

class LedgerManager {
  static final LedgerManager _instance = LedgerManager._internal();
  factory LedgerManager() => _instance;
  LedgerManager._internal();
  void getStatus() {}
}

class Deviceinfo {
  void loadMemoryInfo() {}
}
