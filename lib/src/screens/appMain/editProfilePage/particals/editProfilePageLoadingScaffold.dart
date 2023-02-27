import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EditProfilePageLoadingScaffold extends StatelessWidget {
  const EditProfilePageLoadingScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(166, 227, 233, 1),
        body: Column(
          children: [
            //header
            SafeArea(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Text(
                      "Gamebridge",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                height: 300,
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 100,
                ),
              ),
            )
            //blogs
          ],
        ));
  }
}
