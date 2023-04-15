import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:reminder_app/components/profile.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reminder_app/components/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';


import 'login_page.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import './notificationService.dart';

Random random = new Random();

class todo extends StatefulWidget {
  final token;
  const todo({@required this.token, Key? key}) : super(key: key);

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {
  // late String userId;
  late String email;
  late String name;
  // late String contactNumber;
  late SharedPreferences prefs;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Notifications _notifications = Notifications();


  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    // userId = jwtDecodedToken['_id'];
    this.email = jwtDecodedToken['email'];
    print('${this.email} is logged in');
    this.name = jwtDecodedToken['name'];
    // this.contactNumber = jwtDecodedToken['contactNumber'];
    print('name : ${this.name}');
    getTodoList(this.email);
    print("todo list received");

    // scheduleNotification(title: "sample", description: "sample", Y: DateTime.now().year, M: DateTime.now().month,
    //  D: DateTime.now().day, H: TimeOfDay.now().hour, minute: TimeOfDay.now().minute+2);

    initSharedPref();
    initNotifies();
  }

    //init notifications
  Future initNotifies() async => flutterLocalNotificationsPlugin =
      await _notifications.initNotifies(context);

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var regBody = {
        "email": email,
        "title": _todoTitle.text,
        "desc": _todoDesc.text,
        "datetime" : dateTime.toString()
      };

      var response = await http.post(Uri.parse(addtodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        tz.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
        await _notifications.showNotification(_todoTitle.text, _todoDesc.text, dateTime.millisecondsSinceEpoch, random.nextInt(100000000), flutterLocalNotificationsPlugin);
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getTodoList(email);
      } else {
        print("SomeThing Went Wrong");
      }
      
      // showNotification(_todoTitle.text,_todoDesc.text,100,1,flutterLocalNotificationsPlugin);
    }
  }


  void updateTodo(id) async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var regBody = {
        "id": id,
        "title": _todoTitle.text,
        "desc": _todoDesc.text,
        "datetime" : dateTime.toString()
      };

      print('how are you');
      var response = await http.post(Uri.parse(EditToDo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      print(response);
      print('hello');

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        tz.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
        await _notifications.showNotification(_todoTitle.text, _todoDesc.text, dateTime.millisecondsSinceEpoch, random.nextInt(100000000), flutterLocalNotificationsPlugin);
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getTodoList(email);
      } else {
        print("SomeThing Went Wrong");
      }
      // getTodoList(email);
      // Navigator.pop(context);
    }
  }

  void getTodoList(email) async {
    var regBody = {"email": email};

    var response = await http.post(Uri.parse(getToDoList),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    print(response.statusCode);
    if (response.statusCode == 200) {}
    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];

    setState(() {});
  }

  void deleteItem(id) async {
    var regBody = {"id": id};

    var response = await http.post(Uri.parse(deleteTodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    getTodoList(email);
  }

  void navigateToProfilePage(String email) async {
    var reqBody = {
      "email": email,
    };

    var response = await http.post(Uri.parse(gotoProfile),
        headers: {"content-Type": "application/json"},
        body: jsonEncode(reqBody));
    print(response);
    var jsonResponse = jsonDecode(response.body);


    if (jsonResponse['status'] != 'FAILED') {
    var data = jsonResponse['data'];
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => profile(data: data)));
    }
  }    

  // Future<void> scheduleNotification({
  //                 required String title,
  //                 required String description,
  //                 required int Y,
  //                 required int M,
  //                 required int D,
  //                 required int H,
  //                 required int minute
  // }) async {
  //   print("trying for notification");
  //   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //       'channel id', 'channel name','channel description',
  //       // icon: 'mipmap/launcher_icon',
  //       // largeIcon: DrawableResourceAndroidBitmap('mipmap/launcher_icon'),
  //       priority: Priority.max,
  //       importance: Importance.max);
    
  //   print("android notification");

  //   // var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       // iOS: iOSPlatformChannelSpecifics
  //     );

  //   tz.initializeTimeZones();
  //   print("timezone initialised");

  //   final startTime = DateTime(Y,M,D,H,minute);
  //   final currentTime = DateTime.now();

  //   final diff_dy = currentTime.difference(startTime).inDays;
  //   final diff_hr = currentTime.difference(startTime).inHours;
  //   final diff_mn = currentTime.difference(startTime).inMinutes;
  //   final diff_sc = currentTime.difference(startTime).inSeconds;

  //   flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     title,
  //     description,
  //     tz.TZDateTime.now(tz.local)
  //         .add(Duration(minutes: -diff_mn, hours: -diff_hr, seconds: -diff_sc)),
  //     platformChannelSpecifics,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //     payload: "Your Custom Data",
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white)),
                  subtitle: Text(email,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white54)),
                  // trailing: const CircleAvatar(
                  //   radius: 30,
                  //   backgroundImage: AssetImage('assets/images/user.JPG'),
                  // ),
                  trailing: IconButton(
                      onPressed: () {
                        navigateToProfilePage(email);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //   builder: (context) => profile()));
                      },
                      icon: Icon(Icons.person)),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: items == null
                    ? null
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            key: const ValueKey(0),
                            //  endActionPane: ActionPane(
                            //    motion: const ScrollMotion(),
                            //    dismissible: DismissiblePane(onDismissed: () {}),
                            //  children: [
                            //    SlidableAction(
                            //      backgroundColor: Color(0xFFFE4A49),
                            //      foregroundColor: Colors.white,
                            //      icon: Icons.delete,
                            //      label: 'Delete',
                            //      onPressed: (BuildContext context) {
                            //        print('${items![index]['_id']}');
                            //        deleteItem('${items![index]['_id']}');
                            //      },

                            //    ),
                            //  ],
                            //  ),
                            child: Card(
                              borderOnForeground: false,
                              child: ListTile(
                                onTap: () {
                                  print('${items![index]['title']}');
                                  print('${items![index]['description']}');
                                  _showDescription('${items![index]['title']}',
                                      '${items![index]['description']}',
                                      '${items![index]['datetime']}');
                                },
                                onLongPress: () {
                                  print('${items![index]['_id']}');
                                  print('${items![index]['title']}');
                                  print('${items![index]['description']}');
                                  _todoTitle.text = '${items![index]['title']}';
                                  _todoDesc.text =
                                      '${items![index]['description']}';
                                  _displayTextEditDialog(
                                      '${items![index]['_id']}',
                                      '${items![index]['title']}',
                                      '${items![index]['description']}');
                                },
                                leading: Icon(Icons.task),
                                title: Text('${items![index]['title']}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      deleteItem('${items![index]['_id']}'),
                                ),
                                //  subtitle: Text('${items![index]['desc']}'),
                                // trailing: Icon('${items![index]['completed']}' == true
                                //     ? Icons.check_box
                                //     : Icons.check_box_outline_blank,
                                //   key: Key('completed-icon-$index'),
                                // ),
                              ),
                            ),
                          );
                        }),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _todoTitle.clear();
          _todoDesc.clear();
          selectedDate = DateTime.now();
          selectedTime = TimeOfDay.now();
          _displayTextInputDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add-ToDo',
      ),
    );
  }

  Future<void> _showDescription(String title, String description, String datetime) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description),
                Text(datetime)
              ],
            )

          );
        });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Add To-Do'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _todoTitle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Title",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _todoDesc,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: ListTile(
                        title: Row(
                      children: [
                        // Expanded(
                        //   child:  IconButton(
                        //     onPressed: () {
                        //       _selectDate(context);
                        //       showDate = true;
                        //       print(getDate());
                        //     },
                        //     icon: Icon(Icons.calendar_month)
                        //   ),
                        // ),
                        Expanded(
                          child: IconButton(
                              onPressed: () {
                                _selectDateTime(context);
                              },
                              icon: Icon(Icons.access_time)),
                        ),
                        Expanded(
                          child: IconButton(
                              onPressed: () {
                                addTodo();
                              },
                              icon: Icon(Icons.check)),
                        )
                      ],
                    )),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       _selectTime(context);
                  //       showTime = true;
                  //     },
                  //     child: const Text('Timer Picker'),
                  //   ),
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       _selectDateTime(context);
                  //       showDateTime = true;
                  //     },
                  //     child: const Text('Select Date and Time Picker'),
                  //   ),
                  // ),
                  // showDateTime
                  //     ? Center(child: Text(getDateTime()))
                  //     : const SizedBox(),

                  // ElevatedButton(onPressed: (){
                  //   addTodo();
                  //   }, child: Text("Add"))
                ],
              ));
        });
  }

  
  
  // Future<void> showNotification(int id, String title, String body, String time) async {
  //   if(DateTime.now() == time){
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tz.TZDateTime.now(tz.local).add(Duration(
  //           seconds: 1)), //schedule the notification to show after 2 seconds.
  //       NotificationDetails(
          
  //         // Android details
  //         android: AndroidNotificationDetails('main_channel', 'Main Channel',"reminder",
  //             // channelDescription: ,
  //             importance: Importance.defaultImportance,
  //             priority: Priority.defaultPriority),
  //         // iOS details
  //         iOS: IOSNotificationDetails(
  //           sound: 'default.wav',
  //           presentAlert: true,
  //           presentBadge: true,
  //           presentSound: true,
  //         ),
  //       ),
        
  //       // Type of time interpretation
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       androidAllowWhileIdle:
  //           true, // To show notification even when the app is closed
  //     );
  //   }
  // }

  Future<void> _displayTextEditDialog(
      String id, String title, String description) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('edit To-Do'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: _todoTitle,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      // labelText: title,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px8(),
                TextField(
                  controller: _todoDesc,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      // labelText: description,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Description",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px8(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: ListTile(
                      title: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              _selectDate(context);
                              showDate = true;
                              print(getDate());
                            },
                            icon: Icon(Icons.calendar_month)),
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              _selectDateTime(context);
                            },
                            icon: Icon(Icons.access_time)),
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              print(id);
                              updateTodo(id);
                            },
                            icon: Icon(Icons.update)),
                      )
                    ],
                  )),
                ),
              ]
                  //   ElevatedButton(onPressed: (){
                  //     print(id);
                  //     updateTodo(id);
                  //     }, child: Text("update"))
                  // ],
                  ));
        });
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;

  int yearOfReminder = DateTime.now().year;
  int monthOfReminder = DateTime.now().month;
  int dayOfReminder = DateTime.now().day;
  int hourOfReminder = TimeOfDay.now().hour;
  int minuteOfReminder = TimeOfDay.now().minute;

  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final dateToday = DateTime.now();
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }
  // select date time picker

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;
    print(date);

    final time = await _selectTime(context);

    if (time == null) return;
    print(time);
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    print(dateTime);
  }

  String getDate() {
    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }

  String getDateTime() {
    // ignore: unnecessary_null_comparison
    if (dateTime == null) {
      return 'select date timer';
    } else {
      print(DateFormat('yyyy-MM-dd HH:mm ss a').format(dateTime));
      return DateFormat('yyyy-MM-dd HH:mm ss a').format(dateTime);
    }
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }
}
