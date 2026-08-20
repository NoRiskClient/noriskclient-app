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
      throw Exception('Failed to post data: ${response.body}');
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

  Future<Map<String, dynamic>> getGiveawayAdminInfo(String giveawayId) async {
    Map<String, dynamic>? data =
        await _fetchData("cosmetics", "giveaways/admin/$giveawayId", null);

    if (data == null) {
      return {};
    } else {
      return data;
    }
  }

  Future<Map<String, dynamic>?> redeemGiveaway(String giveawayId) async {
    final response = await http.post(
      Uri.parse(
          '${getBaseUrl(getUserData['experimental'], "cosmetics")}/giveaways/$giveawayId/redeem?uuid=${getUserData['uuid']}'),
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

  Future<String?> isAndroidAppReleased() async {
    final response = await http
        .get(Uri.parse('https://dl-staging.norisk.gg/android_app_release'));

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes))['currentVersion']
          as String?;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getGamescomInfos() async {
    final response = await http.get(Uri.parse(
        'https://api${getUserData['experimental'] == true ? '-staging' : ''}.norisk.gg/api/v1/discord/gamescom-infos'));

    if (response.statusCode == 200) {
      return response.body == 'null'
          ? null
          : jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }
}
