import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/screens/appMain/otherProfilePage/particals/otherProfilePageScaffold.dart';
import 'package:gamebrige/src/sm/sm_with_riverpod.dart';

class OtherProfilePage extends ConsumerStatefulWidget {
  late var person_id;
  OtherProfilePage({Key? key, required this.person_id}) : super(key: key);

  @override
  ConsumerState<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends ConsumerState<OtherProfilePage> {
  late var token;
  late var user;

  @override
  void initState() {
    super.initState();
    token = ref.read(stoken);
    var res = ref.read(suser);
    user = jsonDecode(res);
  }

  @override
  Widget build(BuildContext context) {
    return OtherProfilePageScaffold(
      token: token,
      user: user,
      person_id: widget.person_id,
    );
  }
}
