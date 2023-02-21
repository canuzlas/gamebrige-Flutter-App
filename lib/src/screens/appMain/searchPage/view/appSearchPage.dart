import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageScaffold.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/state/search_page_state.dart';

import '../controller/searchPageController.dart';
import '../particals/searchPageLoadingScaffold.dart';

class SearchPage extends ConsumerWidget {
  SearchPageController searchPageController = SearchPageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPaageDatas = ref.watch(searchPageFutureTokenAndUserProvider);
    return searchPaageDatas.when(
      loading: () => const SearchPageLoadingScaffold(),
      data: (data) {
        return SearchPageScaffold(
          token: data?["token"],
          user: data?["user"],
          bestUsers: data?["bestUsers"],
        );
      },
      error: (err, stack) => Text(err.toString()),
    );
  }
}
