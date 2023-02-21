import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/controller/searchPageController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/searchPageUsersModel.dart';

SearchPageController searchPageController = SearchPageController();

late SharedPreferences prefs;

Future<Map<String, dynamic>> getTokenAndUserForSearchPage() async {
  prefs = await searchPageController.getSharedPreferences();
  final String? token = prefs.getString("token");
  final user = prefs.getString("user");

  final users = await searchPageController.getBestUsers(token, user);
  return {
    "token": token,
    "user": user,
    "bestUsers": users,
  };
}

final searchPageFutureTokenAndUserProvider = FutureProvider.autoDispose((ref) {
  return getTokenAndUserForSearchPage();
});

// search Users

class SearchedUser extends StateNotifier<Users> {
  SearchedUser() : super(Users([]));

  update(refUsers) {
    state = Users(refUsers);
  }

  getUsers() {
    return state.users;
  }
}

final searchUserNotiProvider = StateNotifierProvider((ref) => SearchedUser());
