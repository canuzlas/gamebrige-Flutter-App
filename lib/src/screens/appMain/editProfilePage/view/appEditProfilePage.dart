import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/editProfilePage/particals/editProfileScaffold.dart';
import 'package:gamebrige/src/screens/appMain/editProfilePage/state/editProfilePage_state.dart';

import '../particals/editProfilePageLoadingScaffold.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userFutureProvider);
    return user.when(
      loading: () => const EditProfilePageLoadingScaffold(),
      data: (data) {
        return EditProfileScaffold(user: data);
      },
      error: (err, stack) => Text(err.toString()),
    );
  }
}
