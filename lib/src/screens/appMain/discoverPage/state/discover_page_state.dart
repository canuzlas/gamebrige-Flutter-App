import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/controller/discoverPageController.dart';
import 'package:shared_preferences/shared_preferences.dart';

DiscoverPageController discoverPageController = DiscoverPageController();

late SharedPreferences prefs;

Future<Map<String, dynamic>> getDatasForDiscoverPage() async {
  prefs = await discoverPageController.getSharedPreferences();
  final String? token = prefs.getString("token");
  final user = prefs.getString("user");

  final blogs = await discoverPageController.getAllBlogs(token);

  return {"token": token, "user": user, "blogs": blogs};
}

final discoverPageFutureProvider = FutureProvider.autoDispose((ref) {
  return getDatasForDiscoverPage();
});
