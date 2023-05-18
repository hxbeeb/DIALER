import 'package:fire/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class logout extends StatefulWidget {
  const logout({super.key});

  @override
  State<logout> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<logout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 169, 104, 104),
        title: Text("CURRENT USER"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 200,
          ),
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 50,
          ),
          SizedBox(
            height: 50,
          ),
          Text("USER: COLLECTION NAME"),
          SizedBox(
            height: 50,
          ),
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mainpage()));
              },
              child: Text("SIGN OUT"))
        ]),
      ),
      backgroundColor: Color.fromARGB(255, 255, 166, 194),
    );
  }
}
