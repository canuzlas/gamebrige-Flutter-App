import 'dart:convert';

import 'package:gamebrige/src/screens/appMain/editProfilePage/controller/editProfilePageController.dart';
import 'package:riverpod/riverpod.dart';

EditProfilePageController editProfilePageController =
    EditProfilePageController();

getUser() async {
  var prefs = await editProfilePageController.getSharedPrafences();
  var user = prefs.getString("user");

  return jsonDecode(user);
}

final userFutureProvider = FutureProvider.autoDispose((ref) => getUser());
