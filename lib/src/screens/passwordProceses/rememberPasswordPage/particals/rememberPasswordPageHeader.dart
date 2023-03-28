import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RememberPasswordPageHeader extends StatelessWidget {
  const RememberPasswordPageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              onPressed: () async {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            const Text(
              "Şifreni yenile",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
