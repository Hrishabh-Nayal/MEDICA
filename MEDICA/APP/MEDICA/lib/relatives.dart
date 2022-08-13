import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RelativesPage extends StatefulWidget {
  const RelativesPage({Key? key}) : super(key: key);

  @override
  _RelativesPageState createState() => _RelativesPageState();
}

class _RelativesPageState extends State<RelativesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  var _userEmail;
  var userData;
  String data = '';
  String newName = '';
  int newPhone = 0;
  bool _isLoading = true;

  getCurrentUser() {
    _user = _auth.currentUser;
    print('user uid:');
    print(_user!.uid);
    print('user email: ');
    print(_user!.email);
    _userEmail = _user!.email;
  }

  getUserData() async {
    DocumentSnapshot dataPath = await FirebaseFirestore.instance
        .collection('users')
        .doc('${_user!.uid}')
        .get();
    print('user data: ');
    if (dataPath.exists) {
      Map<String, dynamic> _userData = dataPath.data() as Map<String, dynamic>;
      print(_userData['ContactInfo']);
      userData = _userData['ContactInfo'];
    }
    setState(() {
      data = userData.toString();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getCurrentUser();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            :
            // Text('Emergency contacts'),
            // Text('Currently logged in with: $_userEmail'),
            // Text(data)
            Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: userData.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          if (userData.length == 0) {
                            return Icon(Icons.refresh);
                          }
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Name: ${userData[index]['name']}'),
                            subtitle: Text(
                                'Contact No: ${userData[index]['contact']}'),
                          );
                        }),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Add Emergency Contact'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: [
                                      TextField(

                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                        ),
                                        onChanged: (val){
                                          newName = val;
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Contact No',
                                        ),
                                        onChanged: (val){
                                          newPhone = int.parse(val);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                    child: Text("Submit"),
                                    onPressed: () async{
                                      List<dynamic> newEntry = [{'name': newName, 'contact': newPhone}];
                                      await FirebaseFirestore.instance.collection('users').doc('${_user!.uid}').update({
                                        'ContactInfo': FieldValue.arrayUnion(newEntry)
                                      }).then((_) => print('Added'));
                                      Navigator.of(context).pop();
                                      getUserData();
                                    }
                                    )
                              ],
                            );
                          });
                    },
                    child: Text('Add Relatives',
                        style: TextStyle(color: Color(0xff1d0029))),
                  )
                ],
              ));
  }
}


