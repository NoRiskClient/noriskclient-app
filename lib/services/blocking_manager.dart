import 'package:noriskclient/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockingManager {
  static final BlockingManager _instance = BlockingManager._internal();
  factory BlockingManager() => _instance;
  BlockingManager._internal();

  Set<String>? _cache;
  String? _cachedForUuid;

  String get _currentUuid => getUserData['uuid'] as String? ?? '';
  String get _storeKey => 'blocked-$_currentUuid';

  Future<Set<String>> _getCache() async {
    final uuid = _currentUuid;
    if (_cachedForUuid != uuid) {
      _cache = null;
      _cachedForUuid = uuid;
    }
    if (_cache != null) return _cache!;
    final prefs = await SharedPreferences.getInstance();
    _cache = (prefs.getStringList(_storeKey) ?? []).toSet();
    return _cache!;
  }

  void invalidate() {
    _cache = null;
    _cachedForUuid = null;
  }

  Future<bool> checkBlocked(String uuid) async {
    return (await _getCache()).contains(uuid);
  }

  Future<List<String>> getBlocked() async {
    return (await _getCache()).toList();
  }

  Future<void> block(String uuid) async {
    final blocked = await _getCache();
    if (blocked.contains(uuid)) return;
    blocked.add(uuid);
    await _persist(blocked);
  }

  Future<void> unblock(String uuid) async {
    final blocked = await _getCache();
    if (!blocked.contains(uuid)) return;
    blocked.remove(uuid);
    await _persist(blocked);
  }

  Future<void> _persist(Set<String> blocked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storeKey, blocked.toList());
  }
}
