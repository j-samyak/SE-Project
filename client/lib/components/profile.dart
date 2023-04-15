import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:reminder_app/components/common/custom_input_field.dart';
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reminder_app/components/model/user.dart';

import 'login_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatefulWidget {
  final data;
  const profile({@required this.data, Key? key}) : super(key: key);

  // const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  late String email;
  late String name;
  late String contactNumber;



  @override
  void initState() {
    super.initState();
    email = widget.data['email'];
    name = widget.data['name'];
    contactNumber = widget.data['contactNumber'];
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

  void updateProfile() async {
    if (displayNameController.text.isNotEmpty &&
        bioController.text.isNotEmpty) {
      var regBody = {
        "name": displayNameController.text,
        "email": email,
        "contactNumber": bioController.text
      };

      print('how are you');
      var response = await http.post(Uri.parse(updateDetails),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      print(response);
      print('hello');

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      Navigator.pop(context);
      // getTodoList(email);
      // Navigator.pop(context);
    }
  }

  void changePassword() async {
    if(newPasswordController.text == confirmPasswordController.text){
      var regBody = {
        "email" : email,
        "password" : newPasswordController.text,
      };
      var body = jsonEncode(regBody);
      var response = await http.post(Uri.parse(updatePassword),
          headers: {"content-Type": "application/json"},
          body: jsonEncode(regBody));
      
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] != "FAILED") {
        Navigator.pop(context);
        Navigator.pop(context);
        passwordChangedMessage();
      }
    }
  } 

  void checkPassword() async {
    if (currentPasswordController.text.isNotEmpty) {
      var reqBody = {
        "email" : email,
        "password": currentPasswordController.text
      };
      var response = await http.post(Uri.parse(checkIfPassword),
          headers: {"content-Type": "application/json"},
          body: jsonEncode(reqBody));
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == "SUCCESS") {
        openNewPasswordField(context);        
      }else{
        incorrectPassword();
      }
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
                ElevatedButton(
                  onPressed: () {
                    openPasswordChangeField(context);
                  },
                  child: Text(
                    "change password",
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
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


  Future<void> openPasswordChangeField(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('enter current password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "current password",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  ElevatedButton(
                    onPressed: (){
                      checkPassword();
                    },
                    child: Text("done")
                  )          
                ],
              ));
        });
  }

  Future<void> openNewPasswordField(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('enter new password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomInputField(
                          controller: newPasswordController,
                          labelText: 'new password',
                          hintText: 'enter new password',
                          isDense: true,
                          validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Password is required!';
                          }
                          return null;
                        },),
                 CustomInputField(
                          controller: confirmPasswordController,
                          labelText: 'confirm password',
                          hintText: 'enter password again',
                          isDense: true,
                          validator: (textValue) {
                          if (textValue != newPasswordController.text) {
                            return 'password does not match';
                          }
                          return null;
                        },),
                  ElevatedButton(
                    onPressed: (){
                      changePassword();
                    },
                    child: Text("change password")
                  )          
                ],
              ));
        });
  }

  void incorrectPassword() {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('enter correct password')),
      );
    
  }

  void passwordChangedMessage() {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('password changed successfully')),
      );
    
  }

}
