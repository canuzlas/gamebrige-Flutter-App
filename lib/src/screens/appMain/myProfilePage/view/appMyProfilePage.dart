import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/particals/myProfilePageLoadingScaffold.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/particals/myProfilePageScaffold.dart';
import 'package:gamebrige/src/screens/appMain/myProfilePage/state/myprofile_page_state.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProfilePageDatas = ref.watch(myProfilePageFutureProvider);

    return myProfilePageDatas.when(
      loading: () => const MyProfilePageLoadingScaffold(),
      data: (data) {
        return MyProfilePageScaffold(
          token: data?["token"],
          user: data?["user"],
          blogs: data?["blogs"],
        );
      },
      error: (err, stack) => Text(err.toString()),
    );
  }
}
