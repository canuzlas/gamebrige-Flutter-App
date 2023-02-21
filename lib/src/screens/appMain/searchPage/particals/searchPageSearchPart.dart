import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/search_page_state.dart';

class SearchPageSearchPart extends ConsumerStatefulWidget {
  final token;
  final user;
  const SearchPageSearchPart({Key? key, this.token, this.user})
      : super(key: key);

  @override
  ConsumerState<SearchPageSearchPart> createState() =>
      _SearchPageSearchPartState();
}

class _SearchPageSearchPartState extends ConsumerState<SearchPageSearchPart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0),
      width: 300,
      //margin: const EdgeInsets.only(top: 120),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: TextFormField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Bir kullanıcı ara',
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (txt) async {
                if (txt.isEmpty) {
                  ref.refresh(searchUserNotiProvider.notifier).update([]);
                } else {
                  var refUsers = await searchPageController.searchUser(
                      widget.token, widget.user, txt);

                  ref.refresh(searchUserNotiProvider.notifier).update(refUsers);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
