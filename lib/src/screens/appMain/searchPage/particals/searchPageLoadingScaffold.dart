import 'package:flutter/material.dart';
import 'package:gamebrige/src/screens/appMain/searchPage/particals/searchPageHeader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchPageLoadingScaffold extends StatefulWidget {
  final token;
  final user;
  final bestUsers;
  const SearchPageLoadingScaffold(
      {Key? key, this.token, this.user, this.bestUsers})
      : super(key: key);

  @override
  State<SearchPageLoadingScaffold> createState() =>
      _SearchPageLoadingScaffoldState();
}

class _SearchPageLoadingScaffoldState extends State<SearchPageLoadingScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
        body: Column(
          children: [
            //header
            const SearchPageHeader(),
            //recommended users
            Container(
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
                      onChanged: (txt) async {},
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                height: 300,
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 100,
                ),
              ),
            )
          ],
        ));
  }
}
