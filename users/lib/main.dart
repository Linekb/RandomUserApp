import 'package:flutter/material.dart';
import 'package:users/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: 'Users', 
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: UserHomePage(),
  ));
}

class UserHomePage extends StatefulWidget {
  UserHomePage({Key key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

Future<List<User>> fetchUsers() async {
  final response = 
    await http.get('https://randomuser.me/api/?results=20');

  List<User> users = [];
  if(response.statusCode == 200) {
    var jsonData = json.decode(response.body);

    List<dynamic> jsonUsers = jsonData['results'];
    for(int i = 0; i < jsonUsers.length; i++) {
      var newUser = jsonUsers[i];
      users.add(User.fromJson(newUser));
    }
  }
  return users;
}

class _UserHomePageState extends State<UserHomePage> {
  Future<List<User>> futureUserList;

  @override
  void initState() {
    super.initState();
    futureUserList = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar( 
         centerTitle: true, 
         title: Text('User oversigt'),
         actions: [
           Icon(Icons.people_alt_sharp)
         ],
       ),
       body: FutureBuilder(
         future: futureUserList,
         builder: (context, snapshot) {
           if(snapshot.hasData) {
             return ListView.builder(
               itemCount: snapshot.data.length,
               itemBuilder: (context, index) {
                 User user = snapshot.data[index];
                 return Card(
                   child: ListTile(
                     title: Text('${user.name}'),
                     subtitle: Text('${user.email}'),
                     leading: Image.network(user.picture)
                     ),
                 );
               },
             );
           }
           return CircularProgressIndicator();
         }),
    );
  }
}
