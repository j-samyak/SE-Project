
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class Notifications {

  late BuildContext _context;

  Future<FlutterLocalNotificationsPlugin> initNotifies(BuildContext context) async{
    this._context = context;
    //-----------------------------| Inicialize local notifications |--------------------------------------
    var status = await Permission.notification.status;
    if(status.isDenied){
      print(status);
      await Permission.notification.request();
    }
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    return flutterLocalNotificationsPlugin;
    //======================================================================================================
  }



  //---------------------------------| Show the notification in the specific time |-------------------------------
  Future showNotification(String title, String description, int time, int id, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id.toInt(),
        title,
        description,
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, time),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'reminder_id', 'reminders', 
                channelDescription: 'reminders_notification_channel',
                importance: Importance.high,
                priority: Priority.high,
                color: Colors.cyanAccent)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  //================================================================================================================


  //-------------------------| Cancel the notify |---------------------------
  Future removeNotify(int notifyId, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    try{
      return await flutterLocalNotificationsPlugin.cancel(notifyId);
    }catch(e){
      return null;
    }
  }

  //==========================================================================


  //-------------| function to inicialize local notifications |---------------------------
  Future onSelectNotification(String payload) async {
    showDialog(
      context: _context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
//======================================================================================


}