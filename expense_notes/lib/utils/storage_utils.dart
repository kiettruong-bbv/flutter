import 'package:expense_notes/constants/storage_key.dart';
import 'package:localstorage/localstorage.dart';

class StorageUtils {
  static final LocalStorage storage = LocalStorage(StorageKey.app);

  static dynamic getItem(String key) {
    return storage.getItem(key);
  }

  static Future setItem(String key, dynamic value) async {
    await storage.setItem(key, value);
  }

  static Future deleteItem(String key) {
    return storage.deleteItem(key);
  }
}
