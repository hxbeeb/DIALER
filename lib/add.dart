import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class MyWidget extends StatefulWidget {
  MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  TextEditingController a = TextEditingController();

  TextEditingController b = TextEditingController();

  var collection = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email as String);
  data() async {
    var data = await collection.get();
    var u = data.size;
    if (u == u++) u += 2;

    u++;
    collection.doc().set({"NAME": a.text, "No": b.text});
    // .then((value) => collection.doc().update({"ID": value.id}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD NUMBER"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 239, 164, 89),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 100,
          ),
          TextFormField(
            controller: a,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: 'NAME',
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: b,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: 'No',
              prefixIcon: Icon(
                Icons.call,
                color: Colors.black,
              ),
            ),
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value!.length < 10) {
                return "enter proper number";
              } else
                return null;
            },
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            child: Container(
              child: Center(
                  child: Text(
                "ADD",
              )),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 249, 138, 97)),
              width: 300,
              height: 30,
            ),
            onTap: () {
              data();

              Navigator.pop(context);
            },
          )
        ]),
      ),
      backgroundColor: Color.fromARGB(255, 255, 156, 119),
    );
  }
}
