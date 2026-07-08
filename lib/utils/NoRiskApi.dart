import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:noriskclient/main.dart';

class NoRiskApi {
  static const String baseUrl = 'https://api.norisk.gg/api/v1/';
  static const String baseExperimentalUrl =
      'https://api-staging.norisk.gg/api/v1/';

  String getBaseUrl(bool experimental, String project) {
    return project == 'wordpress'
        ? 'https://blog.norisk.gg/wp-json/wp/v2'
        : (experimental ? baseExperimentalUrl : baseUrl) + project;
  }

  String getAssetUrl() {
    return 'https://assets.norisk.gg/api/v1/assets/mcreal';
  }

  Future<T?> _fetchData<T>(
      String backend, String endpoint, Map<String, dynamic>? params) async {
    final response = await http.get(
      Uri.parse(
          '${getBaseUrl(getUserData['experimental'], backend)}/$endpoint?uuid=${getUserData['uuid']}${params?.entries.map((e) => '&${e.key}=${e.value}').join() ?? ''}'),
      headers: {'Authorization': 'Bearer ${getUserData['token']}'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as T;
    } else if (response.statusCode == 401) {
      getUpdateStream.sink.add(['signOut']);
      return null;
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }

  Future<T?> _postData<T>(String backend, String endpoint,
      Map<String, dynamic>? body, Map<String, dynamic>? params) async {
    final response = await http.post(
      Uri.parse(
          '${getBaseUrl(getUserData['experimental'], backend)}/$endpoint?uuid=${getUserData['uuid']}${params?.entries.map((e) => '&${e.key}=${e.value}').join() ?? ''}'),
      body: body != null ? jsonEncode(body) : null,
      headers: {
        'Authorization': 'Bearer ${getUserData['token']}',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return T is String
          ? response.body.toString() as T
          : jsonDecode(utf8.decode(response.bodyBytes)) as T;
    } else if (response.statusCode == 401) {
      getUpdateStream.sink.add(['signOut']);
      return null;
    } else {
      throw Exception(
          'Failed to post data (${response.statusCode}): ${response.body}');
    }
  }

  Future<T?> _deleteData<T>(String backend, String endpoint,
      Map<String, dynamic>? body, Map<String, dynamic>? params) async {
    final response = await http.delete(
      Uri.parse(
          '${getBaseUrl(getUserData['experimental'], backend)}/$endpoint?uuid=${getUserData['uuid']}${params?.entries.map((e) => '&${e.key}=${e.value}').join() ?? ''}'),
      body: body != null ? jsonEncode(body) : null,
      headers: {
        'Authorization': 'Bearer ${getUserData['token']}',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return T is! Map && T is! List
          ? response.body.toString() as T
          : jsonDecode(utf8.decode(response.bodyBytes)) as T;
    } else if (response.statusCode == 401) {
      getUpdateStream.sink.add(['signOut']);
      return null;
    } else {
      throw Exception('Failed to post data: ${response.body}');
    }
  }

  Future<Map> getUserProfile(String uuid) async {
    if (getCache['profiles']?.containsKey(uuid) ?? false) {
      return getCache['profiles']![uuid];
    }

    Map? profileData =
        await _fetchData<Map>('mcreal', 'user/profile/$uuid', null);
    if (profileData == null) {
      return {};
    } else {
      getUpdateStream.sink.add(['cacheProfile', uuid, profileData]);
      return profileData;
    }
  }

  Future<List<dynamic>> getBlogPostsAndChangeLogs() async {
    List<dynamic>? data = await _fetchData<List<dynamic>>(
        'wordpress', 'posts', {'categories': '21,2'});
    return data ?? [];
  }

  Future<List<dynamic>> getPrivateChats() async {
    List<dynamic>? data = await _fetchData("messaging", "chat/private", null);

    return data ?? [];
  }

  Future<Map<String, dynamic>> getFriendsByUsername() async {
    Map<String, dynamic>? data =
        await _fetchData<Map<String, dynamic>>("friends", "@me", null);

    return data ?? {'friends': [], 'pending': []};
  }

  Future<Map<String, dynamic>> createOrGetPrivateChat(String recipient) async {
    Map<String, dynamic>? data = await _postData<Map<String, dynamic>>(
        "messaging", "chat/private", {'recipient': recipient}, null);

    return data ?? {};
  }

  Future<String> addFriendByUuid(String uuid) async {
    String? data = await _postData<String>("friends", "$uuid/add", null, null);
    return data ?? '';
  }

  Future<String> removeFriendByUuid(String uuid) async {
    String? data =
        await _deleteData<String>("friends", "$uuid/remove", null, null);
    return data ?? '';
  }

  Future<String?> getUuidByUsername(String username,
      {bool allowRemoteFetch = true}) async {
    final String normalized = username.trim().toLowerCase();
    if (normalized.isEmpty) {
      return null;
    }

    final Map<dynamic, dynamic>? usernames = getCache['usernames'] as Map?;
    if (usernames != null) {
      for (final entry in usernames.entries) {
        final String candidateName =
            entry.value?.toString().toLowerCase() ?? '';
        if (candidateName == normalized) {
          final String candidateUuid = entry.key?.toString() ?? '';
          if (candidateUuid.isNotEmpty) {
            return candidateUuid;
          }
        }
      }
    }

    final Map<dynamic, dynamic>? profiles = getCache['profiles'] as Map?;
    if (profiles != null) {
      for (final entry in profiles.entries) {
        final Map<String, dynamic>? profile =
            (entry.value as Map?)?.cast<String, dynamic>();
        final String ign =
            profile?['nrcUser']?['ign']?.toString().toLowerCase() ?? '';
        if (ign == normalized) {
          final String candidateUuid = entry.key?.toString() ?? '';
          if (candidateUuid.isNotEmpty) {
            return candidateUuid;
          }
        }
      }
    }

    if (!allowRemoteFetch) {
      return null;
    }

    final http.Response response = await http.get(Uri.parse(
        'https://api.mojang.com/users/profiles/minecraft/${username.trim()}'));
    if (response.statusCode != 200 || response.body.isEmpty) {
      return null;
    }

    final Map<String, dynamic> data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final String compactUuid = data['id']?.toString() ?? '';
    if (compactUuid.length != 32) {
      return null;
    }

    final String formattedUuid =
        '${compactUuid.substring(0, 8)}-${compactUuid.substring(8, 12)}-${compactUuid.substring(12, 16)}-${compactUuid.substring(16, 20)}-${compactUuid.substring(20, 32)}';

    getUpdateStream.sink.add(['loadUsername', formattedUuid]);
    return formattedUuid;
  }

  Future<String> addFriendByName(String name) async {
    final String? uuid = await getUuidByUsername(name);
    if (uuid == null || uuid.isEmpty) {
      throw Exception('Could not resolve UUID for username: $name');
    }
    return addFriendByUuid(uuid);
  }

  Future<String> removeFriendByName(String name) async {
    final String? uuid = await getUuidByUsername(name);
    if (uuid == null || uuid.isEmpty) {
      throw Exception('Could not resolve UUID for username: $name');
    }
    return removeFriendByUuid(uuid);
  }

  Future<List<dynamic>> getChatMessages(String chatId, int page) async {
    List<dynamic>? data = await _fetchData(
        "messaging", "chat/$chatId/messages", {'page': page.toString()});

    return data ?? [];
  }

  Future<Map<String, dynamic>> sendChatMessage(
      String chatId, String content) async {
    return await _postData(
        "messaging", "chat/$chatId/messages", {'content': content}, null);
  }

  Future<String> deleteChatMessage(String chatId, String messageId) async {
    return await _deleteData(
        "messaging", "chat/$chatId/messages", {'messageID': messageId}, null);
  }

  Future<Map<String, dynamic>?> redeemGamescom(String username) async {
    final response = await http.post(
      Uri.parse(
          '${getBaseUrl(getUserData['experimental'], "cosmetics")}/giveaways/gamescom/redeem?uuid=${getUserData['uuid']}&target=$username'),
      body: null,
      headers: {
        'Authorization': 'Bearer ${getUserData['token']}',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      getUpdateStream.sink.add(['signOut']);
      return null;
    } else {
      return {'error': utf8.decode(response.bodyBytes)};
    }
  }

  Future<List<dynamic>?> getGamescomEvents() async {
    print('https://cdn.norisk.gg/backend-resources/gamescom_events.json');
    final response = await http.get(Uri.parse(
        'https://cdn.norisk.gg/backend-resources/gamescom_events.json'));

    if (response.statusCode == 200) {
      return response.body == 'null'
          ? null
          : jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getUserPermissions() async {
    List? permissions = await _fetchData<List>('core', 'permissions', null);
    if (permissions == null) {
      return [];
    } else {
      return permissions;
    }
  }
}
