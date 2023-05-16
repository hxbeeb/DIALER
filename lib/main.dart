import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/add.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: const MyHomePage(
        title: 'DIALER',
      ),
      debugShowCheckedModeBanner: false,

      // theme:ThemeData(brightness:Brightness.light),
      // darkTheme: ThemeData(brightness: Brightness.dark),
      // themeMode: ThemeMode.light,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var collection = FirebaseFirestore.instance.collection("USERS");
  late List<Map<String, dynamic>> items;
  bool isload = false;

  _incrementCounter() async {
    List<Map<String, dynamic>> temp = [];
    DocumentReference d;
    var data = await collection.get();
    data.docs.forEach((e) {
      temp.add(e.data());
    });

    // collection.add({"NAME": "HABEEB SALEH AL HUSSAIN"});
    // var a = await collection.get();
    // var b = a.docs.first.id;
    // collection.doc(b).set({"NAME": "HABEEB SALEH",
    // "No":"9032789348"});
    setState(() {
      items = temp;
      if (isload == false)
        isload = true;
      else
        isload = false;
      // _counter = a.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
        ),
        actions: [
          TextButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyWidget()));
            },
          ),
        ],
      ),
      body: isload
          ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, Index) {
                return Card(
                  child: ListTile(
                    title: Text(items[Index]["NAME"] ?? "UNKNOWN"),
                    subtitle: Text(items[Index]["No"] ?? "UNAVAILABLE"),
                    leading: CircleAvatar(
                      child: InkWell(onDoubleTap: () {
                        FirebaseFirestore.instance
                            .collection("USERS")
                            .doc(items[Index]["ID"])
                            .delete();
                      }),
                      backgroundColor: Colors.black,
                    ),
                    trailing: Container(
                      child: Row(
                        children: [
                          // Container(
                          //   child: IconButton(
                          //     icon: Icon(Icons.call),
                          //     onPressed: () {
                          //       FlutterPhoneDirectCaller.callNumber("9032789348");
                          //     },
                          //   ),
                          // ),
                          SizedBox(
                            width: 100,
                          ),
                          Container(
                              child: IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {
                              FlutterPhoneDirectCaller.callNumber(
                                  items[Index]["No"] ?? "");
                            },
                          ))
                        ],
                      ),
                      width: 150,
                      height: 100,
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("NO DATA")),
      floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.visibility)),
    );
  }
}
