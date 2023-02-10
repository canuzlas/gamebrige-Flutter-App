import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void initNotification() {
  AwesomeNotifications().initialize(
      'resource://drawable/logo',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      debug: false);
}
