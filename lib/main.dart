import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FirebaseUser user;

  _MyHomePageState() {
    fetchToDo();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void fetchToDo() {
    if (user == null) return;
    Firestore.instance.collection(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.ac_unit)),
              Tab(icon: Icon(Icons.ac_unit)),
              Tab(icon: Icon(Icons.ac_unit)),
            ],
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  RaisedButton(
                    child: Text("Google Sign in"),
                    onPressed: () async {
                      GoogleSignInAccount account =
                          await _googleSignIn.signIn();
                      GoogleSignInAuthentication auth =
                          await account.authentication;
                      user = await FirebaseAuth.instance.signInWithGoogle(
                        accessToken: auth.accessToken,
                        idToken: auth.idToken,
                      );
                      fetchToDo();
                    },
                  )
                ],
              ),
            ),
            Text("tab2"),
            Text("tab3"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
