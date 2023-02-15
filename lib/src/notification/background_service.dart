import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

onStart(ServiceInstance serviceInstance) async {
  var status = await Permission.notification.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    return null;
  } else {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Hatırlatma',
            body: 'Arada bir mesajlarını kontrol etmeyi unutma',
            actionType: ActionType.Default));
    Timer.periodic(new Duration(seconds: 43200), (timer) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Hatırlatma',
              body: 'Arada bir mesajlarını kontrol etmeyi unutma',
              actionType: ActionType.Default));
    });
  }
}

bool onBackground(ServiceInstance serviceInstance) {
  return true;
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,
      onBackground: onBackground,
    ),
  );
  service.startService();
}
