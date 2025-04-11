import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Configuración para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS solo si no es web
    final DarwinInitializationSettings? initializationSettingsIOS =
        (!kIsWeb && Platform.isIOS)
            ? DarwinInitializationSettings(
                requestAlertPermission: true,
                requestBadgePermission: true,
                requestSoundPermission: true,
                notificationCategories: [
                  DarwinNotificationCategory(
                    'admin_category',
                    actions: [
                      DarwinNotificationAction.plain(
                        'id_1',
                        'Abrir',
                      ),
                      DarwinNotificationAction.plain(
                        'id_2',
                        'Cerrar',
                        options: {
                          DarwinNotificationActionOption.destructive,
                        },
                      ),
                    ],
                  ),
                ],
              )
            : null;

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notificación tocada: ${response.payload}');
        print('Acción seleccionada: ${response.actionId}');
      },
    );

    // Configuración específica para iOS (solo si no es web)
    if (!kIsWeb && Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    print('Servicio de notificaciones inicializado');
  }

  Future<void> showNotification(String title, String body) async {
    // Configuración para Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'admin_channel',
      'Administrador',
      importance: Importance.max,
      priority: Priority.high,
      channelDescription: 'Canal para notificaciones de administración',
      icon: '@mipmap/ic_notification',
      actions: [
        AndroidNotificationAction(
          'id_1',
          'Abrir',
        ),
        AndroidNotificationAction(
          'id_2',
          'Cerrar',
          cancelNotification: true,
        ),
      ],
    );

    // Configuración para iOS
    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      threadIdentifier: 'thread_id',
      categoryIdentifier: 'admin_category',
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'payload_data',
    );

    print('Notificación mostrada: Título: $title, Cuerpo: $body');
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print(
          'Notificación recibida en segundo plano: ${message.notification!.title}');
      await showNotification(
        message.notification!.title ?? 'Nueva notificación',
        message.notification!.body ?? 'Tienes un nuevo mensaje',
      );
    }
  }

  Future<bool> requestIOSPermissions() async {
    if (Platform.isIOS && !kIsWeb) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      return result ?? false;
    }
    return false;
  }
}
