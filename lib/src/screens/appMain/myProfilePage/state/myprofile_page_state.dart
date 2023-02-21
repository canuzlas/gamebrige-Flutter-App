import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/controller/myProfilePageController.dart';
import 'package:shared_preferences/shared_preferences.dart';

MyProfilePageController myProfilePageController = MyProfilePageController();

late SharedPreferences prefs;

Future<Map<String, dynamic>> getDatasForMyProfilePage() async {
  prefs = await myProfilePageController.getSharedPreferences();
  final String? token = prefs.getString("token");
  final user = prefs.getString("user");
  final blogs =
      await myProfilePageController.getMyBlogs(token, jsonDecode(user!));

  return {"token": token, "user": jsonDecode(user!), "blogs": blogs};
}

final myProfilePageFutureProvider = FutureProvider.autoDispose((ref) {
  return getDatasForMyProfilePage();
});
