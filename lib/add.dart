import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();
  var collection = FirebaseFirestore.instance.collection("USERS");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ADD NUMBER"),
          centerTitle: true,
          backgroundColor: Colors.pink,
          elevation: 0,
        ),
        body: Column(children: [
          SizedBox(
            height: 100,
          ),
          TextFormField(
            validator: (value) {},
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
                  color: Color.fromARGB(255, 228, 31, 17)),
              width: 300,
              height: 30,
            ),
            onTap: () {
              collection
                  .add({"NAME": a.text, "No": b.text, "ID": null}).then((doc) {
                collection.doc(doc.id).update({"ID": doc.id});
                print("your id is =${doc.id}");
              });
              Navigator.pop(context);
            },
          )
        ]));
  }
}
