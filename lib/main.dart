import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamebrige/src/notification/awesome_notification_init.dart';
import 'package:gamebrige/src/router/router.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //dot.env initiliaze
  await dotenv.load(fileName: ".env");
  //flutterfire initialize
  await Firebase.initializeApp(
    name: "com-uzlas-gamebrige",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //awesome notification initialize
  initNotification();
  //background service
  //await initializeBackgroundService();
  //adsense
  //MobileAds.instance.initialize();
  //ProviderScope => from riverpod for state management
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      onGenerateRoute: GeneratedRouter.router,
      initialRoute: "/",
    );
  }
}
