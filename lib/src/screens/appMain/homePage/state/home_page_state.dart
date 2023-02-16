import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/homePage/controller/homePageController.dart';
import 'package:shared_preferences/shared_preferences.dart';

HomePageController homePageController = HomePageController();

late SharedPreferences prefs;

Future<Map<String, dynamic>> getDatasForHomePage() async {
  prefs = await homePageController.getSharedPreferences();
  final String? token = prefs.getString("token");
  final user = prefs.getString("user");

  final blogs = await homePageController.getFollowedsBlogs(token, user);

  return {"token": token, "user": user, "blogs": blogs};
}

final getDataProvider = Provider((ref) => getDatasForHomePage());

final homePageFutureProvider = FutureProvider.autoDispose((ref) {
  final datas = ref.watch(getDataProvider);
  return datas;
});
