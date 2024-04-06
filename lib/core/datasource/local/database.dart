import 'dart:io';

import 'package:cashbook/objectbox.g.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  static Store? _store;

  static Future<AppDatabase> create() async {
    if (_store != null && !_store!.isClosed()) {
      return AppDatabase();
    }
    final Directory directory = await getApplicationDocumentsDirectory();
    _store = await openStore(
      directory: join(directory.path, 'app_db'),
    );
    return AppDatabase();
  }

  int insert<T>(T entity) {
    return _store!.box<T>().put(entity);
  }

  Future<List<T>> getAll<T>() async {
    return _store!.box<T>().getAll();
  }

  static Future<bool> dropDatabase() async {
    if (_store == null) return false;
    _store!.close();
    await Directory(_store!.directoryPath).delete(recursive: true);
    return true;
  }

  static bool close() {
    if (_store == null) return false;
    _store!.close();
    return true;
  }

  void dispose() {
    _store?.close();
  }

  get box => _store!.box;
}
