import 'package:fire/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class logout extends StatefulWidget {
  const logout({super.key});

  @override
  State<logout> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<logout> {
  @override
  Widget build(BuildContext context) {
    var name = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 239, 164, 89),
        title: Text("CURRENT USER"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
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
            Text("USER: $name"),
            SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 249, 138, 97)),
              child: TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => mainpage()));
                  },
                  child: Text("SIGN OUT")),
            )
          ]),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 156, 119),
    );
  }
}
