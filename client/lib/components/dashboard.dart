// import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:reminder_app/components/todo.dart';
// import 'package:reminder_app/components/profile.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';

// class Dashboard extends StatefulWidget {
//   final token;
//   const Dashboard({super.key, required this.token});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   late String email;
//   late String name;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Map<String, dynamic> jwtDecodedtoken = JwtDecoder.decode(widget.token);

//     email = jwtDecodedtoken['email'];
//     name = jwtDecodedtoken['name'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: const BorderRadius.only(
//                 bottomRight: Radius.circular(50),
//               ),
//             ),
//             child: Column(
//               children: [
//                 const SizedBox(height: 50),
//                 ListTile(
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 30),
//                   title: Text(name,
//                       style: Theme.of(context)
//                           .textTheme
//                           .headlineSmall
//                           ?.copyWith(color: Colors.white)),
//                   subtitle: Text(email,
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(color: Colors.white54)),
//                   // trailing: const CircleAvatar(
//                   //   radius: 30,
//                   //   backgroundImage: AssetImage('assets/images/user.JPG'),
//                   // ),
//                 ),
//                 const SizedBox(height: 30)
//               ],
//             ),
//           ),
//           Container(
//             color: Theme.of(context).primaryColor,
//             child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.only(topLeft: Radius.circular(200))),
//                 child: ListTile(
//                   title: Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => todo()));
//                             },
//                             child: Text('todo list')),
//                       ),
//                       Expanded(
//                         child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => profile()));
//                             },
//                             child: Text('profile')),
//                       ),
//                     ],
//                   ),
//                 )
//                 // child:
//                 //
//                 //        ElevatedButton(
//                 //                onPressed: () {
//                 //
//                 //                   Navigator.push(
//                 //                        context,
//                 //                        MaterialPageRoute(
//                 //                        builder: (context) =>todo()));
//                 //                },
//                 //        child: Text('todo list')),
//                 //         child: ElevatedButton(
//                 //             onPressed: () {
//                 //
//                 //         Navigator.push(
//                 //             context,
//                 //             MaterialPageRoute(
//                 //                 builder: (context) =>profile()));
//                 //         },
//                 //         child: Text('profile')),

//                 ),
//           ),
//           const SizedBox(height: 50)
//         ],
//       ),
//     );
//   }

//   // itemDashboard(String title, IconData iconData, Color background) => Container(
//   //   decoration: BoxDecoration(
//   //       color: Colors.white,
//   //       borderRadius: BorderRadius.circular(10),
//   //       boxShadow: [
//   //         BoxShadow(
//   //             offset: const Offset(0, 5),
//   //             color: Theme.of(context).primaryColor.withOpacity(.2),
//   //             spreadRadius: 2,
//   //             blurRadius: 5
//   //         )
//   //       ]
//   //   ),
//   //   child: Column(
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: [
//   //       Container(
//   //           padding: const EdgeInsets.all(10),
//   //           decoration: BoxDecoration(
//   //             color: background,
//   //             shape: BoxShape.circle,
//   //           ),
//   //
//   //           child: Icon(iconData, color: Colors.white)
//   //       ),
//   //
//   //       const SizedBox(height: 8),
//   //       Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
//   //     ],
//   //
//   //   ),
//   // );
// }
