import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:login_signup/components/model/user.dart';

import 'login_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



class profile extends StatefulWidget {

  final token;
  const profile({@required this.token,Key? key}) : super(key: key);

  // const profile({super.key});

  @override
  State<profile> createState() => _profileState();

}


class _profileState extends State<profile> {

    TextEditingController displayNameController = TextEditingController();
    TextEditingController bioController = TextEditingController();
    bool isLoading = false;

    late String email;
    late String name;
    late String contactNumber;   
    // User user;
    
    // @override
    // void initState() {
    //   super.initState();
    //   getUser();
    // }
    
    // getUser() async {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    //   user = User.fromDocument(doc);
    //   displayNameController.text = user.name;
    //   bioController.text = user.bio;
    //   setState(() {
    //     isLoading = false;
    //   });
    // }

    @override
    void initState() {
      super.initState();
      Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

      email = jwtDecodedToken['email'];
      name = jwtDecodedToken['name'];
      contactNumber = jwtDecodedToken['contactNumber'];
      displayNameController.text = name;
      bioController.text = contactNumber;
    }

    Column buildDisplayNameField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                "Display Name",
                style: TextStyle(color: Colors.grey),
              )),
          TextField(
            controller: displayNameController,
            decoration: InputDecoration(
              hintText: "Update Display Name",
            ),
          )
        ],
      );
    }

    Column buildBioField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                "contact number",
                style: TextStyle(color: Colors.grey),
              )),
          TextField(
            controller: bioController,
            decoration: InputDecoration(
              hintText: "enter new contact number",
            ),
          )
        ],
      );
    }

    void updateProfile() async{
      if(displayNameController.text.isNotEmpty && bioController.text.isNotEmpty){

        var regBody = {
          "name":displayNameController.text,
          "email" : email,          
          "contactNumber":bioController.text
        };

        print('how are you');
        var response = await http.post(Uri.parse(updateDetails),
            headers: {"Content-Type":"application/json"},
            body: jsonEncode(regBody)
        );

        print(response);
        print('hello');

        var jsonResponse = jsonDecode(response.body);

        print(jsonResponse['status']);

        Navigator.pop(context);
        // getTodoList(email);
        // Navigator.pop(context);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () => updateProfile(),
              icon: Icon(
                Icons.done,
                size: 30.0,
                color: Colors.green,
              ),
            ),
          ],
        ),
         body: //isLoading
        //     ? circularProgress()
        //     :
           ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16.0,
                      bottom: 8.0,
                    ),
                    // child: CircleAvatar(
                    //   radius: 50.0,
                    //   backgroundImage:
                    //   CachedNetworkImageProvider(user.photoUrl),
                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        buildDisplayNameField(),
                        buildBioField(),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      displayNameController.text = email;
                      bioController.text = contactNumber;
                      Navigator.pop(context);
                    },
                    child: Text(
                      "restore previous data",
                      style: TextStyle(
                        // color: Theme
                        //     .of(context)
                        //     .primaryColor,
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextButton.icon(
                      onPressed: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>LoginPage()));
                      },
                      icon: Icon(Icons.logout, color: Colors.red),
                      label: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }