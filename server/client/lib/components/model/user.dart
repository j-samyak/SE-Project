class User{
  String name;
  String email;
  String contactNumber;
  String password;

  User(
      this.name ,
      this.email,
      this.contactNumber,
      this.password,
      );

  Map<String,dynamic> toJson()=> {
    'name': name,
    'email_id': email,
    'contact_no': contactNumber,
    'password': password,
  };
}