import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/homePage/controller/homePageController.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageScaffold.dart';
import 'package:gamebrige/src/screens/appMain/homePage/state/home_page_state.dart';

import '../particals/homePageLoadingScaffold.dart';

class HomePage extends ConsumerWidget {
  HomePageController homePageController = HomePageController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homePaageDatas = ref.watch(homePageFutureProvider);

    return homePaageDatas.when(
      loading: () => HomePageLoadingScaffold(),
      data: (data) {
        homePageController.getPermissions();
        return HomePageScaffold(
          token: data?["token"],
          user: data?["user"],
          blogs: data?["blogs"],
        );
      },
      error: (err, stack) =>
          SafeArea(child: Center(child: Text(err.toString()))),
    );
  }
}
