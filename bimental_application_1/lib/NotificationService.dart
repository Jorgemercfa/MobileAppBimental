import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Manejar la acción cuando el usuario toca la notificación
        print('Notificación tocada: ${response.payload}');
        print(
            'Acción seleccionada: ${response.actionId}'); // Muestra la acción seleccionada
        // Aquí puedes agregar lógica adicional, como navegar a una pantalla específica
      },
    );

    print('Servicio de notificaciones inicializado'); // Mensaje de depuración
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'admin_channel', // ID del canal
      'Administrador', // Nombre del canal
      importance: Importance.max,
      priority: Priority.high,
      channelDescription: 'Canal para notificaciones de administración',
      icon:
          '@mipmap/ic_notification', // Ícono personalizado para la notificación
      actions: [
        AndroidNotificationAction(
          'id_1',
          'Abrir', // Texto del botón de acción
        ),
        AndroidNotificationAction(
          'id_2',
          'Cerrar', // Texto del botón de acción
          cancelNotification:
              true, // Cierra la notificación al tocar esta acción
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload:
          'payload_data', // Datos adicionales que puedes usar al tocar la notificación
    );

    print(
        'Notificación mostrada: Título: $title, Cuerpo: $body'); // Mensaje de depuración
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print(
          'Notificación recibida en segundo plano: ${message.notification!.title}'); // Mensaje de depuración
      await showNotification(
        message.notification!.title ?? 'Nueva notificación',
        message.notification!.body ?? 'Tienes un nuevo mensaje',
      );
    }
  }
}
