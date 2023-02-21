import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/particals/discoverPageScaffold.dart';
import 'package:gamebrige/src/screens/appMain/discoverPage/state/discover_page_state.dart';

import '../particals/discoverPageLoadingScaffold.dart';

class DiscoverPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoverPageDatas = ref.watch(discoverPageFutureProvider);

    return discoverPageDatas.when(
      loading: () => const DiscoverPageLoadingPage(),
      data: (data) {
        return DiscoverPageScaffold(
          token: data?["token"],
          user: data?["user"],
          blogs: data?["blogs"],
        );
      },
      error: (err, stack) => Text(err.toString()),
    );
  }
}
