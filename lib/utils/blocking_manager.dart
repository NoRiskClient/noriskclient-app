import 'package:noriskclient/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockingManager {
  Map<String, dynamic> userData = getUserData;

  Future<bool> checkBlocked(String uuid) async {
    List<String> blocked = await getStore();
    return blocked.contains(uuid);
  }

  Future<List<String>> getBlocked() async {
    return await getStore();
  }

  Future<void> block(String uuid) async {
    List<String> blocked = await getStore();
    if (blocked.contains(uuid)) return;
    blocked.add(uuid);
    saveStore(blocked);
  }

  Future<void> unblock(String uuid) async {
    List<String> blocked = await getStore();
    if (!blocked.contains(uuid)) return;
    blocked.remove(uuid);
    saveStore(blocked);
  }

  Future<List<String>> getStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('blocked-${userData['uuid']}') ?? [];
  }

  void saveStore(List<String>? blocked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('blocked-${userData['uuid']}', blocked ?? []);
  }
}
