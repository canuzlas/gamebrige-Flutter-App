import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/homePage/controller/homePageController.dart';
import 'package:gamebrige/src/screens/appMain/homePage/particals/homePageScaffold.dart';
import 'package:gamebrige/src/screens/appMain/homePage/state/home_page_state.dart';

import '../particals/homePageLoadingScaffold.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  HomePageController homePageController = HomePageController();

  @override
  Widget build(BuildContext context) {
    final homePaageDatas = ref.watch(homePageFutureProvider);
    return homePaageDatas.when(
      loading: () => HomePageLoadingScaffold(),
      data: (data) {
        homePageController.getPermissions();
        homePageController.createMessageListenerForNotification(data?["user"]);
        return HomePageScaffold(
          token: data?["token"],
          user: data?["user"],
          blogs: data?["blogs"],
          gettingData: false,
        );
      },
      error: (err, stack) => Text(err.toString()),
    );
  }
}
